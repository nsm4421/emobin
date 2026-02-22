import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/create_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_by_year_month_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/get_feed_entry_by_id_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/hard_delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/soft_delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/update_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/upload_pending_feed_entries_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  group('FeedUseCase', () {
    late MockFeedRepository repository;
    late FeedUseCase feedUseCase;

    setUp(() {
      repository = MockFeedRepository();
      feedUseCase = FeedUseCase(repository);
    });

    test('각 getter가 올바른 유스케이스 타입을 반환한다', () {
      expect(
        feedUseCase.observeLocalEntries,
        isA<ObserveLocalFeedEntriesUseCase>(),
      );
      expect(
        feedUseCase.fetchLocalEntries,
        isA<FetchLocalFeedEntriesUseCase>(),
      );
      expect(
        feedUseCase.fetchLocalEntriesByYearMonth,
        isA<FetchLocalFeedEntriesByYearMonthUseCase>(),
      );
      expect(feedUseCase.getById, isA<GetLocalFeedEntryByIdUseCase>());
      expect(feedUseCase.createLocalEntry, isA<CreateLocalFeedEntryUseCase>());
      expect(feedUseCase.updateLocalEntry, isA<UpdateLocalFeedEntryUseCase>());
      expect(
        feedUseCase.softDeleteLocalEntry,
        isA<SoftDeleteLocalFeedEntryUseCase>(),
      );
      expect(
        feedUseCase.hardDeleteLocalEntry,
        isA<HardDeleteLocalFeedEntryUseCase>(),
      );
      expect(
        feedUseCase.syncPendingLocalEntriesToRemote,
        isA<SyncPendingLocalFeedEntriesToRemoteUseCase>(),
      );
    });

    test('각 getter에서 생성된 유스케이스가 동일 repository를 사용한다', () async {
      final entry = buildFeedEntry();
      final draft = buildFeedEntryDraft();
      final entries = <FeedEntry>[entry];
      const year = 2024;
      const month = 1;

      final fetchResult = Right<FeedFailure, List<FeedEntry>>(entries);
      final fetchByYearMonthResult = Right<FeedFailure, List<FeedEntry>>(
        entries,
      );
      final getByIdResult = Right<FeedFailure, FeedEntry?>(entry);
      final createResult = Right<FeedFailure, FeedEntry>(entry);
      final updateResult = Right<FeedFailure, FeedEntry>(entry);
      final softDeleteResult = Right<FeedFailure, void>(null);
      final hardDeleteResult = Right<FeedFailure, void>(null);
      final syncResult = Right<FeedFailure, int>(1);

      when(
        () => repository.watchLocalEntries(),
      ).thenAnswer((_) => Stream.value(entries));
      when(
        () => repository.fetchLocalEntries(),
      ).thenAnswer((_) async => fetchResult);
      when(
        () => repository.fetchLocalEntriesByYearMonth(year: year, month: month),
      ).thenAnswer((_) async => fetchByYearMonthResult);
      when(
        () => repository.getById(entry.id),
      ).thenAnswer((_) async => getByIdResult);
      when(
        () => repository.createLocalEntry(draft),
      ).thenAnswer((_) async => createResult);
      when(
        () => repository.updateLocalEntry(entry),
      ).thenAnswer((_) async => updateResult);
      when(
        () => repository.softDeleteLocalEntry(entry.id),
      ).thenAnswer((_) async => softDeleteResult);
      when(
        () => repository.hardDeleteLocalEntry(entry.id),
      ).thenAnswer((_) async => hardDeleteResult);
      when(
        () => repository.syncPendingLocalEntriesToRemote(),
      ).thenAnswer((_) async => syncResult);

      await expectLater(feedUseCase.observeLocalEntries(), emits(entries));
      await feedUseCase.fetchLocalEntries();
      await feedUseCase.fetchLocalEntriesByYearMonth(year: year, month: month);
      await feedUseCase.getById(entry.id);
      await feedUseCase.createLocalEntry(draft);
      await feedUseCase.updateLocalEntry(entry);
      await feedUseCase.softDeleteLocalEntry(entry.id);
      await feedUseCase.hardDeleteLocalEntry(entry.id);
      await feedUseCase.syncPendingLocalEntriesToRemote();

      verify(() => repository.watchLocalEntries()).called(1);
      verify(() => repository.fetchLocalEntries()).called(1);
      verify(
        () => repository.fetchLocalEntriesByYearMonth(year: year, month: month),
      ).called(1);
      verify(() => repository.getById(entry.id)).called(1);
      verify(() => repository.createLocalEntry(draft)).called(1);
      verify(() => repository.updateLocalEntry(entry)).called(1);
      verify(() => repository.softDeleteLocalEntry(entry.id)).called(1);
      verify(() => repository.hardDeleteLocalEntry(entry.id)).called(1);
      verify(() => repository.syncPendingLocalEntriesToRemote()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
