import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('FetchLocalFeedEntriesUseCase', () {
    late MockFeedRepository repository;
    late FetchLocalFeedEntriesUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = FetchLocalFeedEntriesUseCase(repository);
    });

    test('목록 조회 성공 결과를 그대로 반환한다', () async {
      final entries = <FeedEntry>[buildFeedEntry()];
      final expected = Right<FeedFailure, List<FeedEntry>>(entries);

      when(
        () => repository.fetchLocalEntries(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.fetchLocalEntries()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('목록 조회 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, List<FeedEntry>>(failure);

      when(
        () => repository.fetchLocalEntries(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.fetchLocalEntries()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
