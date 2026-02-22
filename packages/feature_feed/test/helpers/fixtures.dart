import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/entity/feed_record_status.dart';

final DateTime fixedNow = DateTime(2024, 1, 1, 12, 0, 0);

FeedEntry buildFeedEntry({
  String id = 'entry_1',
  String? serverId,
  String? title = '오늘의 기록',
  String note = '오늘은 기분이 좋아요',
  List<String> hashtags = const <String>['happy'],
  String? imageLocalPath,
  String? imageRemotePath,
  String? imageRemoteUrl,
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
    title: title,
    note: note,
    hashtags: hashtags,
    imageLocalPath: imageLocalPath,
    imageRemotePath: imageRemotePath,
    imageRemoteUrl: imageRemoteUrl,
    createdAt: createdAt ?? fixedNow,
    updatedAt: updatedAt,
    deletedAt: deletedAt,
    isDraft: isDraft,
    syncStatus: syncStatus,
    lastSyncedAt: lastSyncedAt,
  );
}

FeedEntryDraft buildFeedEntryDraft({
  String? title = '오늘의 기록',
  String note = '오늘은 기분이 좋아요',
  List<String> hashtags = const <String>['happy'],
  String? imageLocalPath,
  String? imageRemotePath,
  String? imageRemoteUrl,
  DateTime? createdAt,
  bool isDraft = false,
}) {
  return FeedEntryDraft(
    title: title,
    note: note,
    hashtags: hashtags,
    imageLocalPath: imageLocalPath,
    imageRemotePath: imageRemotePath,
    imageRemoteUrl: imageRemoteUrl,
    createdAt: createdAt,
    isDraft: isDraft,
  );
}

FeedRecordStatus buildFeedRecordStatus({
  bool todayDone = false,
  int streakDays = 0,
  int thisWeekCount = 0,
}) {
  return FeedRecordStatus(
    todayDone: todayDone,
    streakDays: streakDays,
    thisWeekCount: thisWeekCount,
  );
}
