import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:feature_auth/src/domain/entity/profile.dart';
import 'package:feature_auth/src/domain/usecase/scenario/update_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('UpdateProfileUseCase', () {
    late MockAuthRepository repository;
    late UpdateProfileUseCase useCase;

    setUp(() {
      repository = MockAuthRepository();
      useCase = UpdateProfileUseCase(repository);
    });

    test('프로필 수정 성공 결과를 그대로 반환한다', () async {
      final profile = buildProfile(bio: '새 소개글', avatarUrl: 'avatar.png');
      final expected = Right<AuthFailure, Profile>(profile);

      when(
        () => repository.updateProfile(bio: '새 소개글', avatarUrl: 'avatar.png'),
      ).thenAnswer((_) async => expected);

      final result = await useCase(bio: '새 소개글', avatarUrl: 'avatar.png');

      expect(result, same(expected));
      verify(
        () => repository.updateProfile(bio: '새 소개글', avatarUrl: 'avatar.png'),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('프로필 수정 실패 결과를 그대로 반환한다', () async {
      final failure = AuthFailure.unknown();
      final expected = Left<AuthFailure, Profile>(failure);

      when(
        () => repository.updateProfile(bio: '변경', avatarUrl: null),
      ).thenAnswer((_) async => expected);

      final result = await useCase(bio: '변경');

      expect(result, same(expected));
      verify(
        () => repository.updateProfile(bio: '변경', avatarUrl: null),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
