import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateLocalFeedEntryUseCase {
  final FeedRepository _repository;

  CreateLocalFeedEntryUseCase(this._repository);

  Future<Either<FeedFailure, FeedEntry>> call(FeedEntryDraft draft) {
    return _repository.createLocalEntry(draft);
  }
}
