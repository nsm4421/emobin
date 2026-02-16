import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/entity/feed_profile.dart';

final DateTime fixedNow = DateTime(2024, 1, 1, 12, 0, 0);

FeedProfile buildFeedProfile({
  String id = 'user_1',
  String username = 'tester',
  String? avatarUrl = 'https://example.com/avatar.png',
}) {
  return FeedProfile(id: id, username: username, avatarUrl: avatarUrl);
}

FeedEntry buildFeedEntry({
  String id = 'entry_1',
  String? serverId,
  String emotion = 'joy',
  String? note = '오늘은 기분이 좋아요',
  int? intensity = 4,
  String createdBy = 'user_1',
  FeedProfile? profile,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? resolvedAt,
  DateTime? deletedAt,
  FeedSyncStatus syncStatus = FeedSyncStatus.localOnly,
  DateTime? lastSyncedAt,
}) {
  return FeedEntry(
    id: id,
    serverId: serverId,
    emotion: emotion,
    note: note,
    intensity: intensity,
    createdBy: createdBy,
    profile: profile ?? buildFeedProfile(id: createdBy),
    createdAt: createdAt ?? fixedNow,
    updatedAt: updatedAt,
    resolvedAt: resolvedAt,
    deletedAt: deletedAt,
    syncStatus: syncStatus,
    lastSyncedAt: lastSyncedAt,
  );
}

FeedEntryDraft buildFeedEntryDraft({
  String emotion = 'joy',
  String? note = '오늘은 기분이 좋아요',
  int? intensity = 4,
  DateTime? createdAt,
  String createdBy = 'user_1',
  FeedProfile? profile,
}) {
  return FeedEntryDraft(
    emotion: emotion,
    note: note,
    intensity: intensity,
    createdAt: createdAt,
    createdBy: createdBy,
    profile: profile ?? buildFeedProfile(id: createdBy),
  );
}
