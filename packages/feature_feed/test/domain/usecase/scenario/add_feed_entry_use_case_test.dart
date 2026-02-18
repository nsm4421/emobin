import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/scenario/create_feed_entry_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('CreateLocalFeedEntryUseCase', () {
    late MockFeedRepository repository;
    late CreateLocalFeedEntryUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = CreateLocalFeedEntryUseCase(repository);
    });

    test('항목 생성 성공 결과를 그대로 반환한다', () async {
      final draft = buildFeedEntryDraft();
      final entry = buildFeedEntry();
      final expected = Right<FeedFailure, FeedEntry>(entry);

      when(
        () => repository.createLocalEntry(draft),
      ).thenAnswer((_) async => expected);

      final result = await useCase(draft);

      expect(result, same(expected));
      verify(() => repository.createLocalEntry(draft)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('항목 생성 실패 결과를 그대로 반환한다', () async {
      final draft = buildFeedEntryDraft(hashtags: const <String>[]);
      final failure = FeedFailure.invalidEntry();
      final expected = Left<FeedFailure, FeedEntry>(failure);

      when(
        () => repository.createLocalEntry(draft),
      ).thenAnswer((_) async => expected);

      final result = await useCase(draft);

      expect(result, same(expected));
      verify(() => repository.createLocalEntry(draft)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
