import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:feature_auth/src/domain/usecase/scenario/delete_account_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

void main() {
  group('DeleteAccountUseCase', () {
    late MockAuthRepository repository;
    late DeleteAccountUseCase useCase;

    setUp(() {
      repository = MockAuthRepository();
      useCase = DeleteAccountUseCase(repository);
    });

    test('회원탈퇴 성공 결과를 그대로 반환한다', () async {
      final expected = Right<AuthFailure, void>(null);

      when(() => repository.deleteAccount()).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.deleteAccount()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('회원탈퇴 실패 결과를 그대로 반환한다', () async {
      final failure = AuthFailure.notAuthenticated();
      final expected = Left<AuthFailure, void>(failure);

      when(() => repository.deleteAccount()).thenAnswer((_) async => expected);

      final result = await useCase();

      expect(result, same(expected));
      verify(() => repository.deleteAccount()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
