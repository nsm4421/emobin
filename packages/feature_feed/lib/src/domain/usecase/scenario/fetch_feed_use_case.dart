import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchLocalFeedEntriesUseCase {
  final FeedRepository _repository;

  FetchLocalFeedEntriesUseCase(this._repository);

  Future<Either<FeedFailure, List<FeedEntry>>> call({
    int? limit,
    int offset = 0,
  }) {
    if (limit == null && offset == 0) {
      return _repository.fetchLocalEntries();
    }
    return _repository.fetchLocalEntries(limit: limit, offset: offset);
  }
}
