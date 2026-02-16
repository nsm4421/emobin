import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:feature_auth/src/domain/usecase/scenario/sign_out_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('SignOutUseCase', () {
    late MockAuthRepository repository;
    late SignOutUseCase useCase;

    setUp(() {
      repository = MockAuthRepository();
      useCase = SignOutUseCase(repository);
    });

    test('로그아웃 성공 결과를 그대로 반환한다', () async {
      final expected = Right<AuthFailure, void>(null);

      when(() => repository.signOut()).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.signOut()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('로그아웃 실패 결과를 그대로 반환한다', () async {
      final failure = AuthFailure.notAuthenticated();
      final expected = Left<AuthFailure, void>(failure);

      when(() => repository.signOut()).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.signOut()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
