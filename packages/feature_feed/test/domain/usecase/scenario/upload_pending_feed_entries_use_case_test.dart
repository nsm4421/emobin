import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/usecase/scenario/upload_pending_feed_entries_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('SyncPendingLocalFeedEntriesToRemoteUseCase', () {
    late MockFeedRepository repository;
    late SyncPendingLocalFeedEntriesToRemoteUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = SyncPendingLocalFeedEntriesToRemoteUseCase(repository);
    });

    test('동기화 성공 결과를 그대로 반환한다', () async {
      final expected = Right<FeedFailure, int>(2);

      when(
        () => repository.syncPendingLocalEntriesToRemote(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.syncPendingLocalEntriesToRemote()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('동기화 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, int>(failure);

      when(
        () => repository.syncPendingLocalEntriesToRemote(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.syncPendingLocalEntriesToRemote()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
