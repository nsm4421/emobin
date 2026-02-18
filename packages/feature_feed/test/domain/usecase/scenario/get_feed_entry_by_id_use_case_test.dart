import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/scenario/get_feed_entry_by_id_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('GetLocalFeedEntryByIdUseCase', () {
    late MockFeedRepository repository;
    late GetLocalFeedEntryByIdUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = GetLocalFeedEntryByIdUseCase(repository);
    });

    test('단건 조회 성공 결과를 그대로 반환한다', () async {
      final entry = buildFeedEntry();
      final expected = Right<FeedFailure, FeedEntry?>(entry);

      when(
        () => repository.getById(entry.id),
      ).thenAnswer((_) async => expected);

      final result = await useCase(entry.id);

      expect(result, same(expected));
      verify(() => repository.getById(entry.id)).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('단건 조회 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, FeedEntry?>(failure);

      when(
        () => repository.getById('unknown'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('unknown');

      expect(result, same(expected));
      verify(() => repository.getById('unknown')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
