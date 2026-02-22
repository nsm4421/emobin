import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchLocalFeedEntriesByYearMonthUseCase {
  final FeedRepository _repository;

  FetchLocalFeedEntriesByYearMonthUseCase(this._repository);

  Future<Either<FeedFailure, List<FeedEntry>>> call({
    required int year,
    required int month,
  }) {
    return _repository.fetchLocalEntriesByYearMonth(year: year, month: month);
  }
}
