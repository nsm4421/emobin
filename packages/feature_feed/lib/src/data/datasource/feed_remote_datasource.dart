import 'package:feature_feed/src/data/model/feed_entry_model.dart';

abstract class FeedRemoteDataSource {
  Future<List<FeedEntryModel>> fetchEntries({DateTime? since});

  Future<FeedEntryModel> upsertEntry(FeedEntryModel entry);
}
