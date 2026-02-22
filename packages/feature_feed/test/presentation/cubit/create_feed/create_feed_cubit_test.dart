import 'package:feature_feed/src/core/errors/feed_error.dart';
import 'package:feature_feed/src/core/constants/feed_limits.dart';
import 'package:feature_feed/src/domain/entity/feed_entry_draft.dart';
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

    setUpAll(() {
      registerFallbackValue(FeedEntryDraft(hashtags: const <String>[]));
    });

    setUp(() {
      repository = MockFeedRepository();
      feedUseCase = FeedUseCase(repository);
      cubit = CreateFeedCubit(feedUseCase);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('createEntry가 성공하면 created 상태를 방출한다', () async {
      final createdEntry = buildFeedEntry(id: 'entry_created');

      when(
        () => repository.createLocalEntry(any()),
      ).thenAnswer((_) async => Right(createdEntry));

      cubit.emit(
        CreateFeedState.editing((
          title: null,
          hashtags: const <String>['joy'],
          note: 'note',
          imageLocalPath: null,
        )),
      );

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.saveEntry();
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.whenOrNull(loading: (_) => true), isTrue);
      expect(
        emitted.last.maybeWhen(
          created: (isDraft, created) =>
              !isDraft && identical(created, createdEntry),
          orElse: () => false,
        ),
        isTrue,
      );
      verify(() => repository.createLocalEntry(any())).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('createEntry는 hashtags가 없어도 성공한다', () async {
      final createdEntry = buildFeedEntry(id: 'entry_without_hashtags');

      when(
        () => repository.createLocalEntry(any()),
      ).thenAnswer((_) async => Right(createdEntry));

      cubit.emit(
        CreateFeedState.editing((
          title: null,
          hashtags: const <String>[],
          note: 'note',
          imageLocalPath: null,
        )),
      );

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.saveEntry();
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.whenOrNull(loading: (_) => true), isTrue);
      expect(
        emitted.last.maybeWhen(
          created: (isDraft, created) =>
              !isDraft && identical(created, createdEntry),
          orElse: () => false,
        ),
        isTrue,
      );
      verify(() => repository.createLocalEntry(any())).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('createEntry는 note가 비어있으면 실패한다', () async {
      cubit.emit(
        CreateFeedState.editing((
          title: null,
          hashtags: const <String>[],
          note: '',
          imageLocalPath: null,
        )),
      );

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.saveEntry();
      await Future<void>.delayed(Duration.zero);

      expect(
        emitted.last.maybeWhen(
          editing: (_, failure) => failure?.error == FeedError.invalidEntry,
          orElse: () => false,
        ),
        isTrue,
      );
      verifyNever(() => repository.createLocalEntry(any()));

      await subscription.cancel();
    });

    test('createDraft가 성공하면 draft created 상태를 방출한다', () async {
      final createdDraftEntry = buildFeedEntry(
        id: 'draft_created',
        isDraft: true,
      );

      when(
        () => repository.createLocalEntry(any()),
      ).thenAnswer((_) async => Right(createdDraftEntry));

      cubit.emit(
        CreateFeedState.editing((
          title: null,
          hashtags: const <String>[],
          note: 'temp',
          imageLocalPath: null,
        )),
      );

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.saveDraft();
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.whenOrNull(loading: (_) => true), isTrue);
      expect(
        emitted.last.maybeWhen(
          created: (isDraft, _) => isDraft,
          orElse: () => false,
        ),
        isTrue,
      );
      verify(() => repository.createLocalEntry(any())).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('createEntry는 title을 최대 20자로 저장한다', () async {
      final createdEntry = buildFeedEntry(id: 'entry_with_trimmed_title');
      const longTitle = '1234567890123456789012345';
      FeedEntryDraft? capturedDraft;

      when(() => repository.createLocalEntry(captureAny())).thenAnswer((
        invocation,
      ) async {
        capturedDraft = invocation.positionalArguments.first as FeedEntryDraft;
        return Right(createdEntry);
      });

      cubit.emit(
        CreateFeedState.editing((
          title: longTitle,
          hashtags: const <String>[],
          note: 'note',
          imageLocalPath: null,
        )),
      );

      await cubit.saveEntry();
      await Future<void>.delayed(Duration.zero);

      expect(capturedDraft, isNotNull);
      expect(capturedDraft!.title, longTitle.substring(0, feedTitleMaxLength));
      verify(() => repository.createLocalEntry(any())).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('saveImageFromSourcePath는 이미지를 저장하고 경로를 업데이트한다', () async {
      const sourcePath = '/tmp/source.jpg';
      const savedPath = '/tmp/feed_images/saved.jpg';

      when(
        () => repository.saveImageFromSourcePath(sourcePath),
      ).thenAnswer((_) async => Right(savedPath));

      cubit.emit(
        CreateFeedState.editing((
          title: null,
          hashtags: const <String>['joy'],
          note: 'note',
          imageLocalPath: null,
        )),
      );

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.saveImageFromSourcePath(sourcePath);
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.whenOrNull(loading: (_) => true), isTrue);
      expect(
        emitted.last.maybeWhen(
          editing: (data, failure) =>
              data.imageLocalPath == savedPath && failure == null,
          orElse: () => false,
        ),
        isTrue,
      );
      verify(() => repository.saveImageFromSourcePath(sourcePath)).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });

    test('removeImage는 기존 이미지를 삭제하고 경로를 제거한다', () async {
      const existingPath = '/tmp/feed_images/existing.jpg';

      when(
        () => repository.deleteImageByPath(existingPath),
      ).thenAnswer((_) async => const Right(null));

      cubit.emit(
        CreateFeedState.editing((
          title: null,
          hashtags: const <String>[],
          note: 'note',
          imageLocalPath: existingPath,
        )),
      );

      final emitted = <CreateFeedState>[];
      final subscription = cubit.stream.listen(emitted.add);

      await cubit.removeImage();
      await Future<void>.delayed(Duration.zero);

      expect(emitted.first.whenOrNull(loading: (_) => true), isTrue);
      expect(
        emitted.last.maybeWhen(
          editing: (data, failure) =>
              data.imageLocalPath == null && failure == null,
          orElse: () => false,
        ),
        isTrue,
      );
      verify(() => repository.deleteImageByPath(existingPath)).called(1);
      verifyNoMoreInteractions(repository);

      await subscription.cancel();
    });
  });
}
