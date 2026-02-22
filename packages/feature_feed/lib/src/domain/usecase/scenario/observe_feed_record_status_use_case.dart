import 'package:feature_feed/src/domain/entity/feed_record_status.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';

class ObserveLocalFeedRecordStatusUseCase {
  final FeedRepository _repository;

  ObserveLocalFeedRecordStatusUseCase(this._repository);

  Stream<FeedRecordStatus> call() {
    return _repository.watchLocalRecordStatus();
  }
}
