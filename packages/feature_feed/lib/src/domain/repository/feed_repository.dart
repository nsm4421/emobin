import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:fpdart/fpdart.dart';

abstract class FeedRepository {
  Stream<List<FeedEntry>> watchLocalEntries();

  Future<Either<FeedFailure, List<FeedEntry>>> fetchLocalEntries();

  Future<Either<FeedFailure, FeedEntry>> createLocalEntry(FeedEntryDraft draft);

  Future<Either<FeedFailure, FeedEntry>> updateLocalEntry(FeedEntry entry);

  Future<Either<FeedFailure, void>> deleteLocalEntry(String id);

  Future<Either<FeedFailure, int>> syncPendingLocalEntriesToRemote();
}
