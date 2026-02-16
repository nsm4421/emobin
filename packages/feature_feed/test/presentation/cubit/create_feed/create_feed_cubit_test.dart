import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/usecase/feed_use_case.dart';
import 'package:feature_feed/src/presentation/cubit/create_feed/create_feed_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('CreateFeedCubit', () {
    late MockFeedRepository repository;
    late FeedUseCase feedUseCase;
    late CreateFeedCubit cubit;

    setUp(() {
      repository = MockFeedRepository();
      feedUseCase = FeedUseCase(repository);
      cubit = CreateFeedCubit(feedUseCase);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('submit 성공 시 success 상태와 생성 엔트리를 보관한다', () async {
      final draft = buildFeedEntryDraft();
      final createdEntry = buildFeedEntry(id: 'entry_created');

      when(
        () => repository.createLocalEntry(draft),
      ).thenAnswer((_) async => Right(createdEntry));

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.submit(draft);
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.status, CreateFeedStatus.submitting);
      expect(cubit.state.status, CreateFeedStatus.success);
      expect(cubit.state.createdEntry, createdEntry);
      expect(cubit.state.failure, isNull);
      verify(() => repository.createLocalEntry(draft)).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('submit 실패 시 failure 상태와 FeedFailure를 보관한다', () async {
      final draft = buildFeedEntryDraft();
      const failure = FeedFailure.storageFailure();

      when(
        () => repository.createLocalEntry(draft),
      ).thenAnswer((_) async => const Left(failure));

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.submit(draft);
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.status, CreateFeedStatus.submitting);
      expect(cubit.state.status, CreateFeedStatus.failure);
      expect(cubit.state.createdEntry, isNull);
      expect(cubit.state.failure?.code, failure.code);
      verify(() => repository.createLocalEntry(draft)).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('reset 호출 시 initial 상태로 초기화한다', () async {
      final draft = buildFeedEntryDraft();
      final createdEntry = buildFeedEntry(id: 'entry_created');

      when(
        () => repository.createLocalEntry(draft),
      ).thenAnswer((_) async => Right(createdEntry));

      await cubit.submit(draft);
      expect(cubit.state.status, CreateFeedStatus.success);

      cubit.reset();

      expect(cubit.state, const CreateFeedState());
      verify(() => repository.createLocalEntry(draft)).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
