import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_by_year_month_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('FetchLocalFeedEntriesByYearMonthUseCase', () {
    late MockFeedRepository repository;
    late FetchLocalFeedEntriesByYearMonthUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = FetchLocalFeedEntriesByYearMonthUseCase(repository);
    });

    test('연월 조건 목록 조회 성공 결과를 그대로 반환한다', () async {
      const year = 2024;
      const month = 1;
      final entries = <FeedEntry>[buildFeedEntry()];
      final expected = Right<FeedFailure, List<FeedEntry>>(entries);

      when(
        () => repository.fetchLocalEntriesByYearMonth(year: year, month: month),
      ).thenAnswer((_) async => expected);

      final result = await useCase(year: year, month: month);

      expect(result, same(expected));
      verify(
        () => repository.fetchLocalEntriesByYearMonth(year: year, month: month),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('연월 조건 목록 조회 실패 결과를 그대로 반환한다', () async {
      const year = 2024;
      const month = 1;
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, List<FeedEntry>>(failure);

      when(
        () => repository.fetchLocalEntriesByYearMonth(year: year, month: month),
      ).thenAnswer((_) async => expected);

      final result = await useCase(year: year, month: month);

      expect(result, same(expected));
      verify(
        () => repository.fetchLocalEntriesByYearMonth(year: year, month: month),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
