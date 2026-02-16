import 'package:injectable/injectable.dart';

import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:feature_feed/src/domain/usecase/scenario/add_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/update_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/upload_pending_feed_entries_use_case.dart';

@lazySingleton
class FeedUseCase {
  final FeedRepository _repository;

  FeedUseCase(this._repository);

  ObserveLocalFeedEntriesUseCase get observeLocalEntries =>
      ObserveLocalFeedEntriesUseCase(_repository);

  FetchLocalFeedEntriesUseCase get fetchLocalEntries =>
      FetchLocalFeedEntriesUseCase(_repository);

  CreateLocalFeedEntryUseCase get createLocalEntry =>
      CreateLocalFeedEntryUseCase(_repository);

  UpdateLocalFeedEntryUseCase get updateLocalEntry =>
      UpdateLocalFeedEntryUseCase(_repository);

  DeleteLocalFeedEntryUseCase get deleteLocalEntry =>
      DeleteLocalFeedEntryUseCase(_repository);

  SyncPendingLocalFeedEntriesToRemoteUseCase
  get syncPendingLocalEntriesToRemote =>
      SyncPendingLocalFeedEntriesToRemoteUseCase(_repository);
}
