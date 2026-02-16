import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/scenario/update_feed_entry_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('UpdateLocalFeedEntryUseCase', () {
    late MockFeedRepository repository;
    late UpdateLocalFeedEntryUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = UpdateLocalFeedEntryUseCase(repository);
    });

    test('항목 수정 성공 결과를 그대로 반환한다', () async {
      final entry = buildFeedEntry();
      final expected = Right<FeedFailure, FeedEntry>(entry);

      when(
        () => repository.updateLocalEntry(entry),
      ).thenAnswer((_) async => expected);

      final result = await useCase(entry);

      expect(result, same(expected));
      verify(() => repository.updateLocalEntry(entry)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('항목 수정 실패 결과를 그대로 반환한다', () async {
      final entry = buildFeedEntry(id: 'unknown');
      final failure = FeedFailure.entryNotFound();
      final expected = Left<FeedFailure, FeedEntry>(failure);

      when(
        () => repository.updateLocalEntry(entry),
      ).thenAnswer((_) async => expected);

      final result = await useCase(entry);

      expect(result, same(expected));
      verify(() => repository.updateLocalEntry(entry)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
