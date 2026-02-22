import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_record_status.dart';
import 'package:feature_feed/src/domain/usecase/scenario/fetch_feed_record_status_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('FetchLocalFeedRecordStatusUseCase', () {
    late MockFeedRepository repository;
    late FetchLocalFeedRecordStatusUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = FetchLocalFeedRecordStatusUseCase(repository);
    });

    test('집계 조회 성공 결과를 그대로 반환한다', () async {
      final status = buildFeedRecordStatus(
        todayDone: true,
        streakDays: 5,
        thisWeekCount: 5,
      );
      final expected = Right<FeedFailure, FeedRecordStatus>(status);

      when(
        () => repository.fetchLocalRecordStatus(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.fetchLocalRecordStatus()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('집계 조회 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, FeedRecordStatus>(failure);

      when(
        () => repository.fetchLocalRecordStatus(),
      ).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.fetchLocalRecordStatus()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
