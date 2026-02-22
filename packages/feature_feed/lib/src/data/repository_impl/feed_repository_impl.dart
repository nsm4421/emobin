import 'package:injectable/injectable.dart';

import 'package:feature_feed/src/core/constants/feed_limits.dart';
import 'package:feature_feed/src/core/constants/feed_sync_status.dart';
import 'package:feature_feed/src/core/errors/feed_exception.dart';
import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/core/errors/feed_failure_mapper.dart';
import 'package:feature_feed/src/data/datasource/feed_image_storage.dart';
import 'package:feature_feed/src/data/datasource/feed_local_datasource.dart';
import 'package:feature_feed/src/data/datasource/feed_remote_datasource.dart';
import 'package:feature_feed/src/data/mapper/feed_entry_mapper.dart';
import 'package:feature_feed/src/data/repository_impl/feed_repository_sync_mixin.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
import 'package:feature_feed/src/domain/entity/feed_record_status.dart';
import 'package:feature_feed/src/domain/repository/feed_repository.dart';
import 'package:fpdart/fpdart.dart';

@LazySingleton(as: FeedRepository)
class FeedRepositoryImpl
    with FeedRepositorySyncMixin
    implements FeedRepository {
  final FeedLocalDataSource _localDataSource;
  final FeedRemoteDataSource _remoteDataSource;
  final FeedImageStorage _imageStorage;

  FeedRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._imageStorage,
  );

  @override
  Stream<List<FeedEntry>> watchLocalEntries() {
    return _localDataSource.watchEntries().map(
      (entries) => entries.map((entry) => entry.toEntity()).toList(),
    );
  }

  @override
  Stream<FeedRecordStatus> watchLocalRecordStatus() {
    return _localDataSource.watchRecordedDates().map(_buildRecordStatus);
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
  Future<Either<FeedFailure, FeedRecordStatus>> fetchLocalRecordStatus() async {
    try {
      final recordedDates = await _localDataSource.fetchRecordedDates();
      return Right(_buildRecordStatus(recordedDates));
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, List<FeedEntry>>> fetchLocalEntriesByYearMonth({
    required int year,
    required int month,
  }) async {
    try {
      final entries = await _localDataSource.fetchEntriesByYearMonth(
        year: year,
        month: month,
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
      final normalizedDraft = draft.copyWith(
        title: _normalizeTitle(draft.title),
      );
      final model = normalizedDraft.toModel(
        id: id,
        syncStatus: initialSyncStatus,
      );
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
      final normalizedEntry = entry.copyWith(
        title: _normalizeTitle(entry.title),
      );
      final updated = normalizedEntry
          .copyWith(updatedAt: updatedAt, syncStatus: nextStatus)
          .toModel();
      final stored = await _localDataSource.updateEntry(updated);
      return Right(stored.toEntity());
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, void>> softDeleteLocalEntry(String id) async {
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
  Future<Either<FeedFailure, void>> hardDeleteLocalEntry(String id) async {
    try {
      await _localDataSource.hardDeleteEntry(id);
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, String>> saveImageFromSourcePath(
    String sourcePath,
  ) async {
    try {
      final savedPath = await _imageStorage.saveFromSourcePath(sourcePath);
      return Right(savedPath);
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, void>> deleteImageByPath(String localPath) async {
    try {
      await _imageStorage.deleteByPath(localPath);
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  @override
  Future<Either<FeedFailure, int>> backupPendingLocalEntriesToRemote() async {
    try {
      final pending = await _localDataSource.fetchEntriesBySyncStatus({
        FeedSyncStatus.localOnly,
        FeedSyncStatus.pendingUpload,
      });
      await _remoteDataSource.backupEntries(pending);

      for (final entry in pending) {
        final syncedEntry = markSynced(entry);
        await _localDataSource.updateEntry(syncedEntry);
      }

      return Right(pending.length);
    } catch (error, stackTrace) {
      return Left(error.toFeedFailure(stackTrace));
    }
  }

  String? _normalizeTitle(String? raw) {
    final normalized = raw?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    if (normalized.length <= feedTitleMaxLength) return normalized;
    return normalized.substring(0, feedTitleMaxLength);
  }

  FeedRecordStatus _buildRecordStatus(List<DateTime> recordedDates) {
    final today = _dateOnly(DateTime.now().toLocal());
    final recordedDays = recordedDates
        .map((date) => _dateOnly(date.toLocal()))
        .toSet();
    return FeedRecordStatus(
      todayDone: recordedDays.contains(today),
      streakDays: _calculateStreak(recordedDays: recordedDays, today: today),
      thisWeekCount: _countThisWeek(recordedDays: recordedDays, today: today),
    );
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  int _calculateStreak({
    required Set<DateTime> recordedDays,
    required DateTime today,
  }) {
    var streak = 0;
    var cursor = today;
    while (recordedDays.contains(cursor)) {
      streak += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  int _countThisWeek({
    required Set<DateTime> recordedDays,
    required DateTime today,
  }) {
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    var count = 0;
    for (var i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      if (recordedDays.contains(day)) {
        count += 1;
      }
    }
    return count;
  }
}
