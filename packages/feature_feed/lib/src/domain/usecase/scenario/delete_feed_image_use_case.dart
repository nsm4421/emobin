import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteFeedImageUseCase {
  final FeedRepository _repository;

  DeleteFeedImageUseCase(this._repository);

  Future<Either<FeedFailure, void>> call(String localPath) {
    return _repository.deleteImageByPath(localPath);
  }
}
