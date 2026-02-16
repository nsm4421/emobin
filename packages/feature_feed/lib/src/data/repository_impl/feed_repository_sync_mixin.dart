import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/data/model/feed_entry_model.dart';
import 'package:uuid/uuid.dart';

mixin FeedRepositorySyncMixin {
  static const Uuid _uuid = Uuid();

  String nextId() => _uuid.v4();

  FeedSyncStatus resolveUpdateStatus(FeedSyncStatus current) {
    return current == FeedSyncStatus.synced
        ? FeedSyncStatus.pendingUpload
        : current;
  }

  FeedSyncStatus resolveDeleteStatus(FeedSyncStatus current) {
    return current == FeedSyncStatus.synced
        ? FeedSyncStatus.pendingUpload
        : current;
  }

  FeedEntryModel markSynced(FeedEntryModel entry) {
    return entry.copyWith(
      syncStatus: FeedSyncStatus.synced,
      lastSyncedAt: DateTime.now().toUtc(),
    );
  }
}
