import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveFeedImageUseCase {
  final FeedRepository _repository;

  SaveFeedImageUseCase(this._repository);

  Future<Either<FeedFailure, String>> call(String sourcePath) {
    return _repository.saveImageFromSourcePath(sourcePath);
  }
}
