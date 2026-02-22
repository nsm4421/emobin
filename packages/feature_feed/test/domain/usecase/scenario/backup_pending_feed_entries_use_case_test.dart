import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/usecase/scenario/backup_pending_feed_entries_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('BackupPendingLocalFeedEntriesToRemoteUseCase', () {
    late MockFeedRepository repository;
    late BackupPendingLocalFeedEntriesToRemoteUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = BackupPendingLocalFeedEntriesToRemoteUseCase(repository);
    });

    test('백업 성공 결과를 그대로 반환한다', () async {
      final expected = Right<FeedFailure, int>(2);

      when(
        () => repository.backupPendingLocalEntriesToRemote(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.backupPendingLocalEntriesToRemote()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('백업 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, int>(failure);

      when(
        () => repository.backupPendingLocalEntriesToRemote(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.backupPendingLocalEntriesToRemote()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
