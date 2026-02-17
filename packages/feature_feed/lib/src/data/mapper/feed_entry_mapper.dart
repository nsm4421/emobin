import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/data/model/feed_entry_model.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';

extension FeedEntryModelX on FeedEntryModel {
  FeedEntry toEntity() {
    return FeedEntry(
      id: id,
      serverId: serverId,
      emotion: emotion,
      note: note,
      imageLocalPath: imageLocalPath,
      imageRemotePath: imageRemotePath,
      imageRemoteUrl: imageRemoteUrl,
      intensity: intensity,
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
      emotion: emotion,
      note: note,
      imageLocalPath: imageLocalPath,
      imageRemotePath: imageRemotePath,
      imageRemoteUrl: imageRemoteUrl,
      intensity: intensity,
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
      emotion: emotion,
      note: note,
      imageLocalPath: imageLocalPath,
      imageRemotePath: imageRemotePath,
      imageRemoteUrl: imageRemoteUrl,
      intensity: intensity,
      createdAt: resolvedCreatedAt,
      updatedAt: resolvedCreatedAt,
      isDraft: isDraft,
      syncStatus: syncStatus,
    );
  }
}
