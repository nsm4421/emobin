import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';

class ObserveLocalFeedEntriesUseCase {
  final FeedRepository _repository;

  ObserveLocalFeedEntriesUseCase(this._repository);

  Stream<List<FeedEntry>> call() {
    return _repository.watchLocalEntries();
  }
}
