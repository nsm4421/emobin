import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/core/types/feed_stream_payload.dart';
import 'package:feature_feed/src/data/model/feed_entry_model.dart';

abstract class FeedLocalDataSource {
  Stream<FeedStreamPayload> watchEntries();

  Future<List<FeedEntryModel>> fetchEntries({int? limit, int offset = 0});

  Future<FeedEntryModel?> getById(String id);

  Future<FeedEntryModel> addEntry(FeedEntryModel entry);

  Future<FeedEntryModel> updateEntry(FeedEntryModel entry);

  Future<void> hardDeleteEntry(String id);

  Future<List<FeedEntryModel>> fetchEntriesBySyncStatus(
    Set<FeedSyncStatus> statuses,
  );

  Future<void> upsertEntries(List<FeedEntryModel> entries);
}
