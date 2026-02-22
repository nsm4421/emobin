import 'package:feature_feed/src/domain/entity/feed_record_status.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_record_status_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('ObserveLocalFeedRecordStatusUseCase', () {
    late MockFeedRepository repository;
    late ObserveLocalFeedRecordStatusUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = ObserveLocalFeedRecordStatusUseCase(repository);
    });

    test('repository에서 반환한 상태 스트림을 그대로 반환한다', () {
      final status = buildFeedRecordStatus(
        todayDone: true,
        streakDays: 2,
        thisWeekCount: 3,
      );
      final expected = Stream<FeedRecordStatus>.value(status);

      when(
        () => repository.watchLocalRecordStatus(),
      ).thenAnswer((_) => expected);

      final result = useCase();

      expect(result, same(expected));
      verify(() => repository.watchLocalRecordStatus()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
