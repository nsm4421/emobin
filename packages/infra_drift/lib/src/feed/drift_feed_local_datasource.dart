import 'dart:developer' as developer;

import 'package:drift/drift.dart';
import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/core/errors/feed_exception.dart';
import 'package:feature_feed/src/core/types/feed_stream_payload.dart';
import 'package:feature_feed/src/data/datasource/feed_local_datasource.dart';
import 'package:feature_feed/src/data/model/feed_entry_model.dart';
import 'package:injectable/injectable.dart';

import '../core/database/drift_database.dart';
import 'drift_feed_entry_mapper.dart';

@LazySingleton(as: FeedLocalDataSource)
class DriftFeedLocalDataSource
    with DriftFeedEntryMapper
    implements FeedLocalDataSource {
  DriftFeedLocalDataSource(this._database);

  final EmobinDatabase _database;
  static const _logName = 'DriftFeedLocalDataSource';

  @override
  Stream<FeedStreamPayload> watchEntries() {
    _logDebug('watchEntries subscribed');
    final query = _database.select(_database.feedEntries)
      ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
    return query
        .watch()
        .map((rows) {
          _logDebug('watchEntries emission rows=${rows.length}');
          try {
            final mapped = mapRows(rows);
            _logDebug('watchEntries mapped entries=${mapped.length}');
            return mapped;
          } catch (error, stackTrace) {
            _logError(
              'watchEntries mapping failed',
              error: error,
              stackTrace: stackTrace,
            );
            rethrow;
          }
        })
        .handleError((Object error, StackTrace stackTrace) {
          _logError(
            'watchEntries stream failed',
            error: error,
            stackTrace: stackTrace,
          );
        });
  }

  @override
  Future<List<FeedEntryModel>> fetchEntries() async {
    _logDebug('fetchEntries called');
    try {
      final query = _database.select(_database.feedEntries)
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
      final rows = await query.get();
      final mapped = mapRows(rows);
      _logDebug('fetchEntries success entries=${mapped.length}');
      return mapped;
    } catch (error, stackTrace) {
      _logError('fetchEntries failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<FeedEntryModel?> fetchEntry(String id) async {
    _logDebug('fetchEntry called id=$id');
    try {
      final query = _database.select(_database.feedEntries)
        ..where((tbl) => tbl.id.equals(id))
        ..limit(1);
      final row = await query.getSingleOrNull();
      final mapped = row == null ? null : mapRow(row);
      _logDebug('fetchEntry success id=$id found=${mapped != null}');
      return mapped;
    } catch (error, stackTrace) {
      _logError(
        'fetchEntry failed id=$id',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<FeedEntryModel> addEntry(FeedEntryModel entry) async {
    _logDebug('addEntry called id=${entry.id}');
    try {
      await _database.into(_database.feedEntries).insert(toCompanion(entry));
      _logDebug('addEntry success id=${entry.id}');
      return entry;
    } catch (error, stackTrace) {
      _logError(
        'addEntry failed id=${entry.id}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<FeedEntryModel> updateEntry(FeedEntryModel entry) async {
    _logDebug('updateEntry called id=${entry.id}');
    try {
      final updated = await _database
          .update(_database.feedEntries)
          .replace(toCompanion(entry));
      if (!updated) {
        throw const FeedException.entryNotFound();
      }
      _logDebug('updateEntry success id=${entry.id}');
      return entry;
    } catch (error, stackTrace) {
      _logError(
        'updateEntry failed id=${entry.id}',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    _logDebug('deleteEntry called id=$id');
    try {
      final deleted = await (_database.delete(
        _database.feedEntries,
      )..where((tbl) => tbl.id.equals(id))).go();
      if (deleted == 0) {
        throw const FeedException.entryNotFound();
      }
      _logDebug('deleteEntry success id=$id');
    } catch (error, stackTrace) {
      _logError(
        'deleteEntry failed id=$id',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<List<FeedEntryModel>> fetchEntriesBySyncStatus(
    Set<FeedSyncStatus> statuses,
  ) async {
    _logDebug(
      'fetchEntriesBySyncStatus called statuses=${statuses.map((s) => s.value).join(',')}',
    );
    if (statuses.isEmpty) {
      return <FeedEntryModel>[];
    }
    try {
      final values = statuses.map((status) => status.value).toList();
      final query = _database.select(_database.feedEntries)
        ..where((tbl) => tbl.syncStatus.isIn(values))
        ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]);
      final rows = await query.get();
      final mapped = mapRows(rows);
      _logDebug('fetchEntriesBySyncStatus success entries=${mapped.length}');
      return mapped;
    } catch (error, stackTrace) {
      _logError(
        'fetchEntriesBySyncStatus failed',
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> upsertEntries(List<FeedEntryModel> entries) async {
    _logDebug('upsertEntries called entries=${entries.length}');
    if (entries.isEmpty) return;
    try {
      final companions = entries.map(toCompanion).toList();
      await _database.batch((batch) {
        batch.insertAll(
          _database.feedEntries,
          companions,
          mode: InsertMode.insertOrReplace,
        );
      });
      _logDebug('upsertEntries success entries=${entries.length}');
    } catch (error, stackTrace) {
      _logError('upsertEntries failed', error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  void _logDebug(String message) {
    developer.log(message, name: _logName);
  }

  void _logError(
    String message, {
    required Object error,
    required StackTrace stackTrace,
  }) {
    developer.log(
      message,
      name: _logName,
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
