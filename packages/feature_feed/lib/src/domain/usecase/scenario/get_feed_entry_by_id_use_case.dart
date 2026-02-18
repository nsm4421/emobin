import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetLocalFeedEntryByIdUseCase {
  final FeedRepository _repository;

  GetLocalFeedEntryByIdUseCase(this._repository);

  Future<Either<FeedFailure, FeedEntry?>> call(String id) {
    return _repository.getById(id);
  }
}
