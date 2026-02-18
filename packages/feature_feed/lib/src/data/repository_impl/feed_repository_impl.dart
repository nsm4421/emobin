import 'package:injectable/injectable.dart';

import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/core/errors/feed_exception.dart';
import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/core/errors/feed_failure_mapper.dart';
import 'package:feature_feed/src/data/datasource/feed_local_datasource.dart';
import 'package:feature_feed/src/data/datasource/feed_remote_datasource.dart';
import 'package:feature_feed/src/data/mapper/feed_entry_mapper.dart';
import 'package:feature_feed/src/data/repository_impl/feed_repository_sync_mixin.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

@LazySingleton(as: FeedRepository)
class FeedRepositoryImpl
    with FeedRepositorySyncMixin
    implements FeedRepository {
  final FeedLocalDataSource _localDataSource;
  final FeedRemoteDataSource _remoteDataSource;

  FeedRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Stream<List<FeedEntry>> watchLocalEntries() {
    return _localDataSource.watchEntries().map(
      (entries) => entries.map((entry) => entry.toEntity()).toList(),
    );
  }

  @override
  Future<Either<FeedFailure, List<FeedEntry>>> fetchLocalEntries({
    int? limit,
    int offset = 0,
  }) async {
    try {
      final entries = await _localDataSource.fetchEntries(
        limit: limit,
        offset: offset,
      );
      final entities = entries.map((entry) => entry.toEntity()).toList();
      return Right(entities);
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, FeedEntry?>> getById(String id) async {
    try {
      final entry = await _localDataSource.getById(id);
      return Right(entry?.toEntity());
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, FeedEntry>> createLocalEntry(
    FeedEntryDraft draft,
  ) async {
    try {
      final id = nextId();
      final initialSyncStatus = draft.isDraft
          ? FeedSyncStatus.localOnly
          : FeedSyncStatus.pendingUpload;
      final model = draft.toModel(id: id, syncStatus: initialSyncStatus);
      final stored = await _localDataSource.addEntry(model);
      return Right(stored.toEntity());
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, FeedEntry>> updateLocalEntry(
    FeedEntry entry,
  ) async {
    try {
      final updatedAt = DateTime.now().toUtc();
      final nextStatus = resolveUpdateStatus(entry.syncStatus);
      final updated = entry
          .copyWith(updatedAt: updatedAt, syncStatus: nextStatus)
          .toModel();
      final stored = await _localDataSource.updateEntry(updated);
      return Right(stored.toEntity());
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, void>> deleteLocalEntry(String id) async {
    try {
      final existing = await _localDataSource.getById(id);
      if (existing == null) {
        throw const FeedException.entryNotFound();
      }
      final deletedAt = DateTime.now().toUtc();
      final nextStatus = resolveDeleteStatus(existing.syncStatus);
      final deleted = existing.copyWith(
        deletedAt: deletedAt,
        updatedAt: deletedAt,
        syncStatus: nextStatus,
      );
      await _localDataSource.updateEntry(deleted);
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, int>> syncPendingLocalEntriesToRemote() async {
    try {
      final pending = await _localDataSource.fetchEntriesBySyncStatus({
        FeedSyncStatus.localOnly,
        FeedSyncStatus.pendingUpload,
      });
      var uploadedCount = 0;
      for (final entry in pending) {
        final synced = await _remoteDataSource.upsertEntry(entry);
        final syncedEntry = markSynced(synced);
        await _localDataSource.updateEntry(syncedEntry);
        uploadedCount += 1;
      }
      return Right(uploadedCount);
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }
}
