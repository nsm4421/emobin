import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/usecase/scenario/save_feed_image_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('SaveFeedImageUseCase', () {
    late MockFeedRepository repository;
    late SaveFeedImageUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = SaveFeedImageUseCase(repository);
    });

    test('이미지 저장 성공 결과를 그대로 반환한다', () async {
      final expected = Right<FeedFailure, String>('/tmp/saved.jpg');

      when(
        () => repository.saveImageFromSourcePath('/tmp/source.jpg'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('/tmp/source.jpg');

      expect(result, same(expected));
      verify(
        () => repository.saveImageFromSourcePath('/tmp/source.jpg'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('이미지 저장 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, String>(failure);

      when(
        () => repository.saveImageFromSourcePath('/tmp/source.jpg'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('/tmp/source.jpg');

      expect(result, same(expected));
      verify(
        () => repository.saveImageFromSourcePath('/tmp/source.jpg'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
