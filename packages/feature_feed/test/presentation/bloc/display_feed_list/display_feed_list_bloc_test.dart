import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/entity/feed_entry.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/presentation/bloc/display_feed_list/display_feed_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('DisplayFeedListBloc', () {
    late MockFeedRepository repository;
    late FeedUseCase feedUseCase;
    late DisplayFeedListBloc bloc;

    setUp(() {
      repository = MockFeedRepository();
      feedUseCase = FeedUseCase(repository);
      bloc = DisplayFeedListBloc(feedUseCase);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('started 시 첫 페이지를 조회한다', () async {
      final firstPage = List<FeedEntry>.generate(
        20,
        (index) => buildFeedEntry(id: 'entry_$index'),
      );

      when(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).thenAnswer((_) async => Right(firstPage));

      final emitted = <DisplayFeedListState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(const DisplayFeedListEvent.started());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedListStatus.success);
      expect(bloc.state.entries, firstPage);
      expect(bloc.state.hasMore, isTrue);
      expect(emitted.first.status, DisplayFeedListStatus.loading);
      verify(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('started 시 pageSize 초과 응답이어도 hasMore를 유지한다', () async {
      final oversizedFirstPage = List<FeedEntry>.generate(
        21,
        (index) => buildFeedEntry(id: 'entry_$index'),
      );

      when(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).thenAnswer((_) async => Right(oversizedFirstPage));

      bloc.add(const DisplayFeedListEvent.started());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedListStatus.success);
      expect(bloc.state.entries.length, 21);
      expect(bloc.state.hasMore, isTrue);
      verify(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('loadMoreRequested 시 다음 페이지를 이어붙인다', () async {
      final firstPage = List<FeedEntry>.generate(
        20,
        (index) => buildFeedEntry(id: 'entry_$index'),
      );
      final secondPage = List<FeedEntry>.generate(
        7,
        (index) => buildFeedEntry(id: 'entry_${index + 20}'),
      );

      when(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).thenAnswer((_) async => Right(firstPage));
      when(
        () => repository.fetchLocalEntries(limit: 20, offset: 20),
      ).thenAnswer((_) async => Right(secondPage));

      bloc.add(const DisplayFeedListEvent.started());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const DisplayFeedListEvent.loadMoreRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedListStatus.success);
      expect(bloc.state.entries.length, 27);
      expect(bloc.state.hasMore, isFalse);
      verify(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).called(1);
      verify(
        () => repository.fetchLocalEntries(limit: 20, offset: 20),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('refreshRequested 실패 시 failure 상태로 전환', () async {
      const failure = FeedFailure.storageFailure();

      when(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).thenAnswer((_) async => const Left(failure));

      final emitted = <DisplayFeedListState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(const DisplayFeedListEvent.refreshRequested());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedListStatus.failure);
      expect(bloc.state.failure?.code, failure.code);
      expect(emitted.first.status, DisplayFeedListStatus.loading);
      verify(
        () => repository.fetchLocalEntries(limit: 20, offset: 0),
      ).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });
  });
}
