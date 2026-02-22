import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class BackupPendingLocalFeedEntriesToRemoteUseCase {
  final FeedRepository _repository;

  BackupPendingLocalFeedEntriesToRemoteUseCase(this._repository);

  Future<Either<FeedFailure, int>> call() {
    return _repository.backupPendingLocalEntriesToRemote();
  }
}
