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
      ..where((tbl) => tbl.deletedAt.isNull())
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
      ..where((tbl) => tbl.deletedAt.isNull())
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
  Future<List<FeedEntryModel>> fetchEntriesByYearMonth({
    required int year,
    required int month,
  }) async {
    final monthRange = _resolveMonthRange(year: year, month: month);
    final query = _database.select(_database.feedEntries)
      ..where((tbl) => tbl.deletedAt.isNull())
      ..where((tbl) => tbl.createdAt.isBiggerOrEqualValue(monthRange.$1))
      ..where((tbl) => tbl.createdAt.isSmallerThanValue(monthRange.$2))
      ..orderBy([
        (tbl) =>
            OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
      ]);
    final rows = await query.get();
    return mapRows(rows);
  }

  (DateTime, DateTime) _resolveMonthRange({
    required int year,
    required int month,
  }) {
    if (month < 1 || month > 12) {
      throw ArgumentError.value(month, 'month', 'must be between 1 and 12');
    }

    final localMonthStart = DateTime(year, month, 1);
    final localNextMonthStart = DateTime(year, month + 1, 1);
    return (localMonthStart.toUtc(), localNextMonthStart.toUtc());
  }

  @override
  Future<FeedEntryModel?> getById(String id) async {
    final query = _database.select(_database.feedEntries)
      ..where((tbl) => tbl.id.equals(id))
      ..where((tbl) => tbl.deletedAt.isNull())
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
  Future<void> hardDeleteEntry(String id) async {
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
