import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/usecase/scenario/sign_up_with_email_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/mocks.dart';

void main() {
  group('SignUpWithEmailUseCase', () {
    late MockAuthRepository repository;
    late SignUpWithEmailUseCase useCase;

    setUp(() {
      repository = MockAuthRepository();
      useCase = SignUpWithEmailUseCase(repository);
    });

    test('회원가입 성공 결과를 그대로 반환한다', () async {
      final user = buildAuthUser();
      final expected = Right<AuthFailure, AuthUser>(user);

      when(
        () => repository.signUpWithEmail(
          email: 'user@example.com',
          password: 'pw123456',
          username: 'tester',
        ),
      ).thenAnswer((_) async => expected);

      final result = await useCase(
        email: 'user@example.com',
        password: 'pw123456',
        username: 'tester',
      );

      expect(result, same(expected));
      verify(
        () => repository.signUpWithEmail(
          email: 'user@example.com',
          password: 'pw123456',
          username: 'tester',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('회원가입 실패 결과를 그대로 반환한다', () async {
      final failure = AuthFailure.emailAlreadyInUse();
      final expected = Left<AuthFailure, AuthUser>(failure);

      when(
        () => repository.signUpWithEmail(
          email: 'dup@example.com',
          password: 'pw123456',
          username: 'tester',
        ),
      ).thenAnswer((_) async => expected);

      final result = await useCase(
        email: 'dup@example.com',
        password: 'pw123456',
        username: 'tester',
      );

      expect(result, same(expected));
      verify(
        () => repository.signUpWithEmail(
          email: 'dup@example.com',
          password: 'pw123456',
          username: 'tester',
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
