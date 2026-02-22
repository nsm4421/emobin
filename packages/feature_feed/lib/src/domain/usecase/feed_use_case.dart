import 'package:injectable/injectable.dart';

import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:feature_feed/src/domain/usecase/scenario/create_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/delete_feed_image_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_by_year_month_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_record_status_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/get_feed_entry_by_id_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/hard_delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_record_status_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/save_feed_image_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/soft_delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/update_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/backup_pending_feed_entries_use_case.dart';

@lazySingleton
class FeedUseCase {
  final FeedRepository _repository;

  FeedUseCase(this._repository);

  ObserveLocalFeedEntriesUseCase get observeLocalEntries =>
      ObserveLocalFeedEntriesUseCase(_repository);

  ObserveLocalFeedRecordStatusUseCase get observeLocalRecordStatus =>
      ObserveLocalFeedRecordStatusUseCase(_repository);

  FetchLocalFeedEntriesUseCase get fetchLocalEntries =>
      FetchLocalFeedEntriesUseCase(_repository);

  FetchLocalFeedRecordStatusUseCase get fetchLocalRecordStatus =>
      FetchLocalFeedRecordStatusUseCase(_repository);

  FetchLocalFeedEntriesByYearMonthUseCase get fetchLocalEntriesByYearMonth =>
      FetchLocalFeedEntriesByYearMonthUseCase(_repository);

  GetLocalFeedEntryByIdUseCase get getById =>
      GetLocalFeedEntryByIdUseCase(_repository);

  CreateLocalFeedEntryUseCase get createLocalEntry =>
      CreateLocalFeedEntryUseCase(_repository);

  UpdateLocalFeedEntryUseCase get updateLocalEntry =>
      UpdateLocalFeedEntryUseCase(_repository);

  SoftDeleteLocalFeedEntryUseCase get softDeleteLocalEntry =>
      SoftDeleteLocalFeedEntryUseCase(_repository);

  HardDeleteLocalFeedEntryUseCase get hardDeleteLocalEntry =>
      HardDeleteLocalFeedEntryUseCase(_repository);

  SaveFeedImageUseCase get saveFeedImage => SaveFeedImageUseCase(_repository);

  DeleteFeedImageUseCase get deleteFeedImage =>
      DeleteFeedImageUseCase(_repository);

  BackupPendingLocalFeedEntriesToRemoteUseCase
  get backupPendingLocalEntriesToRemote =>
      BackupPendingLocalFeedEntriesToRemoteUseCase(_repository);
}
