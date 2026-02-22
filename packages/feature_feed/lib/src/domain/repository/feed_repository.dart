import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/entity/feed_record_status.dart';
import 'package:fpdart/fpdart.dart';

abstract class FeedRepository {
  Stream<List<FeedEntry>> watchLocalEntries();

  Stream<FeedRecordStatus> watchLocalRecordStatus();

  Future<Either<FeedFailure, List<FeedEntry>>> fetchLocalEntries({
    int? limit,
    int offset = 0,
  });

  Future<Either<FeedFailure, FeedRecordStatus>> fetchLocalRecordStatus();

  Future<Either<FeedFailure, List<FeedEntry>>> fetchLocalEntriesByYearMonth({
    required int year,
    required int month,
  });

  Future<Either<FeedFailure, FeedEntry?>> getById(String id);

  Future<Either<FeedFailure, FeedEntry>> createLocalEntry(FeedEntryDraft draft);

  Future<Either<FeedFailure, FeedEntry>> updateLocalEntry(FeedEntry entry);

  Future<Either<FeedFailure, void>> softDeleteLocalEntry(String id);

  Future<Either<FeedFailure, void>> hardDeleteLocalEntry(String id);

  Future<Either<FeedFailure, String>> saveImageFromSourcePath(
    String sourcePath,
  );

  Future<Either<FeedFailure, void>> deleteImageByPath(String localPath);

  Future<Either<FeedFailure, int>> backupPendingLocalEntriesToRemote();
}
