import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/scenario/observe_feed_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('ObserveLocalFeedEntriesUseCase', () {
    late MockFeedRepository repository;
    late ObserveLocalFeedEntriesUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = ObserveLocalFeedEntriesUseCase(repository);
    });

    test('repository에서 반환한 스트림을 그대로 반환한다', () {
      final entries = <FeedEntry>[buildFeedEntry()];
      final expected = Stream.value(entries);

      when(() => repository.watchLocalEntries()).thenAnswer((_) => expected);

      final result = useCase();

      expect(result, same(expected));
      verify(() => repository.watchLocalEntries()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
