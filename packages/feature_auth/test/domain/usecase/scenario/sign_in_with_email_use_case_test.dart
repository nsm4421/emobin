import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/usecase/scenario/sign_in_with_email_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('SignInWithEmailUseCase', () {
    late MockAuthRepository repository;
    late SignInWithEmailUseCase useCase;

    setUp(() {
      repository = MockAuthRepository();
      useCase = SignInWithEmailUseCase(repository);
    });

    test('로그인 성공 결과를 그대로 반환한다', () async {
      final user = buildAuthUser();
      final expected = Right<AuthFailure, AuthUser>(user);

      when(
        () => repository.signInWithEmail(
          email: 'user@example.com',
          password: 'pw123456',
        ),
      ).thenAnswer((_) async => expected);

      final result = await useCase(
        email: 'user@example.com',
        password: 'pw123456',
      );

      expect(result, same(expected));
      verify(
        () => repository.signInWithEmail(
          email: 'user@example.com',
          password: 'pw123456',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('로그인 실패 결과를 그대로 반환한다', () async {
      final failure = AuthFailure.invalidCredentials();
      final expected = Left<AuthFailure, AuthUser>(failure);

      when(
        () => repository.signInWithEmail(
          email: 'user@example.com',
          password: 'wrong-password',
        ),
      ).thenAnswer((_) async => expected);

      final result = await useCase(
        email: 'user@example.com',
        password: 'wrong-password',
      );

      expect(result, same(expected));
      verify(
        () => repository.signInWithEmail(
          email: 'user@example.com',
          password: 'wrong-password',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
