import 'package:feature_feed/feature_feed.dart'
    show FeedEntryModel, FeedRemoteDataSource;
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

@LazySingleton(as: FeedRemoteDataSource)
class SupabaseFeedRemoteDataSource implements FeedRemoteDataSource {
  SupabaseFeedRemoteDataSource(this._client);

  final sb.SupabaseClient _client;

  void _ensureClientReady() {
    _client.auth;
  }

  @override
  Future<List<FeedEntryModel>> fetchEntries({DateTime? since}) {
    _ensureClientReady();
    throw UnimplementedError(
      'SupabaseFeedRemoteDataSource is not implemented yet.',
    );
  }

  @override
  Future<FeedEntryModel> upsertEntry(FeedEntryModel entry) {
    _ensureClientReady();
    throw UnimplementedError(
      'SupabaseFeedRemoteDataSource is not implemented yet.',
    );
  }
}
