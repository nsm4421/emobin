import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';

final DateTime fixedNow = DateTime(2024, 1, 1, 12, 0, 0);

FeedEntry buildFeedEntry({
  String id = 'entry_1',
  String? serverId,
  String? emotion = 'joy',
  String note = '오늘은 기분이 좋아요',
  int intensity = 4,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? deletedAt,
  bool isDraft = false,
  FeedSyncStatus syncStatus = FeedSyncStatus.localOnly,
  DateTime? lastSyncedAt,
}) {
  return FeedEntry(
    id: id,
    serverId: serverId,
    emotion: emotion,
    note: note,
    intensity: intensity,
    createdAt: createdAt ?? fixedNow,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    isDraft: isDraft,
    syncStatus: syncStatus,
    lastSyncedAt: lastSyncedAt,
  );
}

FeedEntryDraft buildFeedEntryDraft({
  String emotion = 'joy',
  String note = '오늘은 기분이 좋아요',
  int intensity = 4,
  DateTime? createdAt,
  bool isDraft = false,
}) {
  return FeedEntryDraft(
    emotion: emotion,
    note: note,
    intensity: intensity,
    createdAt: createdAt,
    isDraft: isDraft,
  );
}
