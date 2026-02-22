import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/presentation/bloc/display_feed_calendar/display_feed_calendar_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('DisplayFeedCalendarBloc', () {
    late MockFeedRepository repository;
    late FeedUseCase feedUseCase;
    late DisplayFeedCalendarBloc bloc;

    setUp(() {
      repository = MockFeedRepository();
      feedUseCase = FeedUseCase(repository);
      bloc = DisplayFeedCalendarBloc(feedUseCase);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('started 시 선택한 년월 피드를 조회한다', () async {
      final focusedMonth = DateTime(2026, 2);
      final monthEntries = List<FeedEntry>.generate(
        3,
        (index) => buildFeedEntry(id: 'entry_$index'),
      );

      when(
        () => repository.fetchLocalEntriesByYearMonth(year: 2026, month: 2),
      ).thenAnswer((_) async => Right(monthEntries));

      final emitted = <DisplayFeedCalendarState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(DisplayFeedCalendarEvent.started(focusedMonth: focusedMonth));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedCalendarStatus.success);
      expect(bloc.state.focusedMonth, focusedMonth);
      expect(bloc.state.entries, monthEntries);
      expect(emitted.first.status, DisplayFeedCalendarStatus.loading);
      verify(
        () => repository.fetchLocalEntriesByYearMonth(year: 2026, month: 2),
      ).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('monthChanged 시 해당 월로 전환 후 재조회한다', () async {
      final january = DateTime(2026, 1);
      final march = DateTime(2026, 3);
      final januaryEntries = [buildFeedEntry(id: 'entry_1')];
      final marchEntries = List<FeedEntry>.generate(
        2,
        (index) => buildFeedEntry(id: 'entry_${index + 10}'),
      );

      when(
        () => repository.fetchLocalEntriesByYearMonth(year: 2026, month: 1),
      ).thenAnswer((_) async => Right(januaryEntries));
      when(
        () => repository.fetchLocalEntriesByYearMonth(year: 2026, month: 3),
      ).thenAnswer((_) async => Right(marchEntries));

      bloc.add(DisplayFeedCalendarEvent.started(focusedMonth: january));
      await Future<void>.delayed(Duration.zero);
      bloc.add(DisplayFeedCalendarEvent.monthChanged(focusedMonth: march));
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedCalendarStatus.success);
      expect(bloc.state.focusedMonth, march);
      expect(bloc.state.entries, marchEntries);
      verify(
        () => repository.fetchLocalEntriesByYearMonth(year: 2026, month: 1),
      ).called(1);
      verify(
        () => repository.fetchLocalEntriesByYearMonth(year: 2026, month: 3),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('refreshRequested 실패 시 failure 상태로 전환', () async {
      const failure = FeedFailure.storageFailure();

      when(
        () => repository.fetchLocalEntriesByYearMonth(
          year: bloc.state.focusedMonth.year,
          month: bloc.state.focusedMonth.month,
        ),
      ).thenAnswer((_) async => const Left(failure));

      final emitted = <DisplayFeedCalendarState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(const DisplayFeedCalendarEvent.refreshRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedCalendarStatus.failure);
      expect(bloc.state.failure?.code, failure.code);
      expect(emitted.first.status, DisplayFeedCalendarStatus.loading);
      verify(
        () => repository.fetchLocalEntriesByYearMonth(
          year: bloc.state.focusedMonth.year,
          month: bloc.state.focusedMonth.month,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });
  });
}
