import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/create_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_use_case.dart';
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
      expect(feedUseCase.createLocalEntry, isA<CreateLocalFeedEntryUseCase>());
      expect(feedUseCase.updateLocalEntry, isA<UpdateLocalFeedEntryUseCase>());
      expect(feedUseCase.deleteLocalEntry, isA<DeleteLocalFeedEntryUseCase>());
      expect(
        feedUseCase.syncPendingLocalEntriesToRemote,
        isA<SyncPendingLocalFeedEntriesToRemoteUseCase>(),
      );
    });

    test('각 getter에서 생성된 유스케이스가 동일 repository를 사용한다', () async {
      final entry = buildFeedEntry();
      final draft = buildFeedEntryDraft();
      final entries = <FeedEntry>[entry];

      final fetchResult = Right<FeedFailure, List<FeedEntry>>(entries);
      final createResult = Right<FeedFailure, FeedEntry>(entry);
      final updateResult = Right<FeedFailure, FeedEntry>(entry);
      final deleteResult = Right<FeedFailure, void>(null);
      final syncResult = Right<FeedFailure, int>(1);

      when(
        () => repository.watchLocalEntries(),
      ).thenAnswer((_) => Stream.value(entries));
      when(
        () => repository.fetchLocalEntries(),
      ).thenAnswer((_) async => fetchResult);
      when(
        () => repository.createLocalEntry(draft),
      ).thenAnswer((_) async => createResult);
      when(
        () => repository.updateLocalEntry(entry),
      ).thenAnswer((_) async => updateResult);
      when(
        () => repository.deleteLocalEntry(entry.id),
      ).thenAnswer((_) async => deleteResult);
      when(
        () => repository.syncPendingLocalEntriesToRemote(),
      ).thenAnswer((_) async => syncResult);

      await expectLater(feedUseCase.observeLocalEntries(), emits(entries));
      await feedUseCase.fetchLocalEntries();
      await feedUseCase.createLocalEntry(draft);
      await feedUseCase.updateLocalEntry(entry);
      await feedUseCase.deleteLocalEntry(entry.id);
      await feedUseCase.syncPendingLocalEntriesToRemote();

      verify(() => repository.watchLocalEntries()).called(1);
      verify(() => repository.fetchLocalEntries()).called(1);
      verify(() => repository.createLocalEntry(draft)).called(1);
      verify(() => repository.updateLocalEntry(entry)).called(1);
      verify(() => repository.deleteLocalEntry(entry.id)).called(1);
      verify(() => repository.syncPendingLocalEntriesToRemote()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
