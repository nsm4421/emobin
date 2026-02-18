import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class HardDeleteLocalFeedEntryUseCase {
  final FeedRepository _repository;

  HardDeleteLocalFeedEntryUseCase(this._repository);

  Future<Either<FeedFailure, void>> call(String id) {
    return _repository.hardDeleteLocalEntry(id);
  }
}
