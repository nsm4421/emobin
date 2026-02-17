import 'package:drift/drift.dart';
import 'package:feature_feed/feature_feed.dart'
    show FeedEntryModel, FeedSyncStatus;

import '../core/database/drift_database.dart';

mixin DriftFeedEntryMapper {
  List<FeedEntryModel> mapRows(List<FeedEntryRow> rows) {
    return rows.map(mapRow).toList(growable: false);
  }

  FeedEntryModel mapRow(FeedEntryRow row) {
    return FeedEntryModel(
      id: row.id,
      serverId: row.serverId,
      emotion: row.emotion,
      note: row.note ?? '',
      intensity: row.intensity ?? 0,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      deletedAt: row.deletedAt,
      isDraft: row.isDraft,
      syncStatus: FeedSyncStatus.fromString(row.syncStatus),
      lastSyncedAt: row.lastSyncedAt,
    );
  }

  FeedEntriesCompanion toCompanion(FeedEntryModel entry) {
    return FeedEntriesCompanion(
      id: Value(entry.id),
      serverId: Value(entry.serverId),
      emotion: Value(entry.emotion),
      note: Value(entry.note),
      intensity: Value(entry.intensity),
      createdAt: Value(entry.createdAt),
      updatedAt: Value(entry.updatedAt),
      deletedAt: Value(entry.deletedAt),
      isDraft: Value(entry.isDraft),
      syncStatus: Value(entry.syncStatus.value),
      lastSyncedAt: Value(entry.lastSyncedAt),
    );
  }
}
