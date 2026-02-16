import 'dart:async';

import 'package:feature_feed/src/core/errors/feed_error.dart';
import 'package:feature_feed/src/core/errors/feed_exception.dart';
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

    test('started 후 목록 조회 및 스트림 변경 반영', () async {
      final initialEntries = <FeedEntry>[buildFeedEntry(id: 'entry_1')];
      final updatedEntries = <FeedEntry>[
        buildFeedEntry(id: 'entry_2'),
        buildFeedEntry(id: 'entry_1'),
      ];
      final controller = StreamController<List<FeedEntry>>();

      when(
        () => repository.fetchLocalEntries(),
      ).thenAnswer((_) async => Right(initialEntries));
      when(
        () => repository.watchLocalEntries(),
      ).thenAnswer((_) => controller.stream);

      final emitted = <DisplayFeedListState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(const DisplayFeedListEvent.started());
      await Future<void>.delayed(Duration.zero);
      controller.add(updatedEntries);
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedListStatus.success);
      expect(bloc.state.entries, updatedEntries);
      expect(emitted.first.status, DisplayFeedListStatus.loading);
      verify(() => repository.fetchLocalEntries()).called(1);
      verify(() => repository.watchLocalEntries()).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
      await controller.close();
    });

    test('refreshRequested 실패 시 failure 상태로 전환', () async {
      const failure = FeedFailure.storageFailure();

      when(() => repository.fetchLocalEntries()).thenAnswer((_) async {
        return const Left(failure);
      });

      final emitted = <DisplayFeedListState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(const DisplayFeedListEvent.refreshRequested());
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.status, DisplayFeedListStatus.loading);
      expect(bloc.state.status, DisplayFeedListStatus.failure);
      expect(bloc.state.failure?.code, failure.code);
      verify(() => repository.fetchLocalEntries()).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('스트림 에러를 FeedFailure로 매핑한다', () async {
      final controller = StreamController<List<FeedEntry>>();

      when(
        () => repository.fetchLocalEntries(),
      ).thenAnswer((_) async => Right(<FeedEntry>[]));
      when(
        () => repository.watchLocalEntries(),
      ).thenAnswer((_) => controller.stream);

      final emitted = <DisplayFeedListState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(const DisplayFeedListEvent.started());
      await Future<void>.delayed(Duration.zero);
      controller.addError(const FeedException.storageFailure());
      await Future<void>.delayed(Duration.zero);

      expect(bloc.state.status, DisplayFeedListStatus.failure);
      expect(bloc.state.failure?.error, FeedError.storageFailure);
      expect(emitted.last.status, DisplayFeedListStatus.failure);
      verify(() => repository.fetchLocalEntries()).called(1);
      verify(() => repository.watchLocalEntries()).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
      await controller.close();
    });
  });
}
