import 'package:feature_feed/src/core/errors/feed_failure.dart';
import 'package:feature_feed/src/domain/usecase/scenario/delete_feed_image_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('DeleteFeedImageUseCase', () {
    late MockFeedRepository repository;
    late DeleteFeedImageUseCase useCase;

    setUp(() {
      repository = MockFeedRepository();
      useCase = DeleteFeedImageUseCase(repository);
    });

    test('이미지 삭제 성공 결과를 그대로 반환한다', () async {
      final expected = Right<FeedFailure, void>(null);

      when(
        () => repository.deleteImageByPath('/tmp/saved.jpg'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('/tmp/saved.jpg');

      expect(result, same(expected));
      verify(() => repository.deleteImageByPath('/tmp/saved.jpg')).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('이미지 삭제 실패 결과를 그대로 반환한다', () async {
      final failure = FeedFailure.storageFailure();
      final expected = Left<FeedFailure, void>(failure);

      when(
        () => repository.deleteImageByPath('/tmp/saved.jpg'),
      ).thenAnswer((_) async => expected);

      final result = await useCase('/tmp/saved.jpg');

      expect(result, same(expected));
      verify(() => repository.deleteImageByPath('/tmp/saved.jpg')).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
