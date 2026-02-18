import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/data/model/feed_entry_model.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';

extension FeedEntryModelX on FeedEntryModel {
  FeedEntry toEntity() {
    return FeedEntry(
      id: id,
      serverId: serverId,
      note: note,
      hashtags: hashtags,
      imageLocalPath: imageLocalPath,
      imageRemotePath: imageRemotePath,
      imageRemoteUrl: imageRemoteUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      isDraft: isDraft,
      syncStatus: syncStatus,
      lastSyncedAt: lastSyncedAt,
    );
  }
}

extension FeedEntryX on FeedEntry {
  FeedEntryModel toModel() {
    return FeedEntryModel(
      id: id,
      serverId: serverId,
      note: note,
      hashtags: hashtags,
      imageLocalPath: imageLocalPath,
      imageRemotePath: imageRemotePath,
      imageRemoteUrl: imageRemoteUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
      isDraft: isDraft,
      syncStatus: syncStatus,
      lastSyncedAt: lastSyncedAt,
    );
  }
}

extension FeedEntryDraftX on FeedEntryDraft {
  FeedEntryModel toModel({
    required String id,
    DateTime? createdAt,
    FeedSyncStatus syncStatus = FeedSyncStatus.pendingUpload,
  }) {
    final resolvedCreatedAt = (createdAt ?? this.createdAt ?? DateTime.now())
        .toUtc();
    return FeedEntryModel(
      id: id,
      note: note,
      hashtags: hashtags,
      imageLocalPath: imageLocalPath,
      imageRemotePath: imageRemotePath,
      imageRemoteUrl: imageRemoteUrl,
      createdAt: resolvedCreatedAt,
      updatedAt: resolvedCreatedAt,
      isDraft: isDraft,
      syncStatus: syncStatus,
    );
  }
}
