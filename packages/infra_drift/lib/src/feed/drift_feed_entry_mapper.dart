import 'package:drift/drift.dart';
import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/data/model/feed_entry_model.dart';
import 'package:feature_feed/src/data/model/feed_profile_model.dart';

import '../core/database/drift_database.dart';

mixin DriftFeedEntryMapper {
  List<FeedEntryModel> mapRows(List<FeedEntryRow> rows) {
    return rows.map(mapRow).toList();
  }

  FeedEntryModel mapRow(FeedEntryRow row) {
    final hasProfile =
        row.profileId != null ||
        row.profileUsername != null ||
        row.profileAvatarUrl != null;
    final profile = hasProfile
        ? FeedProfileModel(
            id: row.profileId ?? '',
            username: row.profileUsername ?? '',
            avatarUrl: row.profileAvatarUrl,
          )
        : null;

    return FeedEntryModel(
      id: row.id,
      serverId: row.serverId,
      emotion: row.emotion,
      note: row.note,
      intensity: row.intensity,
      createdBy: row.createdBy,
      profile: profile,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      resolvedAt: row.resolvedAt,
      deletedAt: row.deletedAt,
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
      createdBy: Value(entry.createdBy),
      profileId: Value(entry.profile?.id),
      profileUsername: Value(entry.profile?.username),
      profileAvatarUrl: Value(entry.profile?.avatarUrl),
      createdAt: Value(entry.createdAt),
      updatedAt: Value(entry.updatedAt),
      resolvedAt: Value(entry.resolvedAt),
      deletedAt: Value(entry.deletedAt),
      syncStatus: Value(entry.syncStatus.value),
      lastSyncedAt: Value(entry.lastSyncedAt),
    );
  }
}
