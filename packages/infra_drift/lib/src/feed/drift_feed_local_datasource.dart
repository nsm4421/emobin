import 'package:drift/drift.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:injectable/injectable.dart';

import '../core/database/drift_database.dart';
import 'drift_feed_entry_mapper.dart';

@LazySingleton(as: FeedLocalDataSource)
class DriftFeedLocalDataSource
    with DriftFeedEntryMapper
    implements FeedLocalDataSource {
  DriftFeedLocalDataSource(this._database);

  final EmobinDatabase _database;

  @override
  Stream<FeedStreamPayload> watchEntries() {
    final query = _database.select(_database.feedEntries)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map(mapRows);
  }

  @override
  Future<List<FeedEntryModel>> fetchEntries({
    int? limit,
    int offset = 0,
  }) async {
    final query = _database.select(_database.feedEntries)
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    if (limit != null) {
      query.limit(limit, offset: offset);
    }
    final rows = await query.get();
    return mapRows(rows);
  }

  @override
  Future<FeedEntryModel?> fetchEntry(String id) async {
    final query = _database.select(_database.feedEntries)
      ..where((tbl) => tbl.id.equals(id))
      ..limit(1);
    final row = await query.getSingleOrNull();
    return row == null ? null : mapRow(row);
  }

  @override
  Future<FeedEntryModel> addEntry(FeedEntryModel entry) async {
    await _database.into(_database.feedEntries).insert(toCompanion(entry));
    return entry;
  }

  @override
  Future<FeedEntryModel> updateEntry(FeedEntryModel entry) async {
    final updated = await _database
        .update(_database.feedEntries)
        .replace(toCompanion(entry));
    if (!updated) {
      throw const FeedException.entryNotFound();
    }
    return entry;
  }

  @override
  Future<void> deleteEntry(String id) async {
    final deleted = await (_database.delete(
      _database.feedEntries,
    )..where((tbl) => tbl.id.equals(id))).go();
    if (deleted == 0) {
      throw const FeedException.entryNotFound();
    }
  }

  @override
  Future<List<FeedEntryModel>> fetchEntriesBySyncStatus(
    Set<FeedSyncStatus> statuses,
  ) async {
    if (statuses.isEmpty) {
      return <FeedEntryModel>[];
    }
    final values = statuses.map((status) => status.value).toList();
    final query = _database.select(_database.feedEntries)
      ..where((tbl) => tbl.syncStatus.isIn(values))
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return mapRows(rows);
  }

  @override
  Future<void> upsertEntries(List<FeedEntryModel> entries) async {
    if (entries.isEmpty) return;
    final companions = entries.map(toCompanion).toList(growable: false);
    await _database.batch((batch) {
      batch.insertAll(
        _database.feedEntries,
        companions,
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
