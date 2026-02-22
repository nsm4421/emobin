import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_record_status.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchLocalFeedRecordStatusUseCase {
  final FeedRepository _repository;

  FetchLocalFeedRecordStatusUseCase(this._repository);

  Future<Either<FeedFailure, FeedRecordStatus>> call() {
    return _repository.fetchLocalRecordStatus();
  }
}
