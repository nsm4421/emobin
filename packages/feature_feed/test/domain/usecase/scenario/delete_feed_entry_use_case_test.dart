import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/usecase/scenario/hard_delete_feed_entry_use_case.dart';
import 'package:feature_feed/src/domain/usecase/scenario/soft_delete_feed_entry_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('SoftDeleteLocalFeedEntryUseCase', () {
    late MockFeedRepository repository;
    late SoftDeleteLocalFeedEntryUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = SoftDeleteLocalFeedEntryUseCase(repository);
    });

    test('항목 삭제 성공 결과를 그대로 반환한다', () async {
      final expected = Right<FeedFailure, void>(null);

      when(
        () => repository.softDeleteLocalEntry('entry_1'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('entry_1');

      expect(result, same(expected));
      verify(() => repository.softDeleteLocalEntry('entry_1')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('항목 삭제 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.entryNotFound();
      final expected = Left<FeedFailure, void>(failure);

      when(
        () => repository.softDeleteLocalEntry('unknown'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('unknown');

      expect(result, same(expected));
      verify(() => repository.softDeleteLocalEntry('unknown')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });

  group('HardDeleteLocalFeedEntryUseCase', () {
    late MockFeedRepository repository;
    late HardDeleteLocalFeedEntryUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = HardDeleteLocalFeedEntryUseCase(repository);
    });

    test('항목 물리삭제 성공 결과를 그대로 반환한다', () async {
      final expected = Right<FeedFailure, void>(null);

      when(
        () => repository.hardDeleteLocalEntry('entry_1'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('entry_1');

      expect(result, same(expected));
      verify(() => repository.hardDeleteLocalEntry('entry_1')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('항목 물리삭제 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.entryNotFound();
      final expected = Left<FeedFailure, void>(failure);

      when(
        () => repository.hardDeleteLocalEntry('unknown'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('unknown');

      expect(result, same(expected));
      verify(() => repository.hardDeleteLocalEntry('unknown')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
