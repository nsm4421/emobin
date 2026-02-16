import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/entity/profile.dart';
import 'package:feature_auth/src/domain/usecase/auth_use_case.dart';
import 'package:feature_auth/src/domain/usecase/scenario/delete_account_use_case.dart';
import 'package:feature_auth/src/domain/usecase/scenario/observe_auth_state_use_case.dart';
import 'package:feature_auth/src/domain/usecase/scenario/sign_in_with_email_use_case.dart';
import 'package:feature_auth/src/domain/usecase/scenario/sign_out_use_case.dart';
import 'package:feature_auth/src/domain/usecase/scenario/sign_up_with_email_use_case.dart';
import 'package:feature_auth/src/domain/usecase/scenario/update_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  group('AuthUseCase', () {
    late MockAuthRepository repository;
    late AuthUseCase authUseCase;

    setUp(() {
      repository = MockAuthRepository();
      authUseCase = AuthUseCase(repository);
    });

    test('각 getter가 올바른 유스케이스 타입을 반환한다', () {
      expect(authUseCase.deleteAccount, isA<DeleteAccountUseCase>());
      expect(authUseCase.observeAuthState, isA<ObserveAuthStateUseCase>());
      expect(authUseCase.signInWithEmail, isA<SignInWithEmailUseCase>());
      expect(authUseCase.signUpWithEmail, isA<SignUpWithEmailUseCase>());
      expect(authUseCase.signOut, isA<SignOutUseCase>());
      expect(authUseCase.updateProfile, isA<UpdateProfileUseCase>());
    });

    test('각 getter에서 생성된 유스케이스가 동일 repository를 사용한다', () async {
      final authUser = buildAuthUser();
      final profile = buildProfile();
      final authUserResult = Right<AuthFailure, AuthUser>(authUser);
      final profileResult = Right<AuthFailure, Profile>(profile);
      final voidResult = Right<AuthFailure, void>(null);

      when(
        () => repository.signInWithEmail(
          email: 'user@example.com',
          password: 'pw123456',
        ),
      ).thenAnswer((_) async => authUserResult);
      when(
        () => repository.signUpWithEmail(
          email: 'new@example.com',
          password: 'pw123456',
          username: 'tester',
        ),
      ).thenAnswer((_) async => authUserResult);
      when(() => repository.signOut()).thenAnswer((_) async => voidResult);
      when(
        () => repository.deleteAccount(),
      ).thenAnswer((_) async => voidResult);
      when(
        () => repository.updateProfile(bio: 'bio', avatarUrl: 'avatar.png'),
      ).thenAnswer((_) async => profileResult);
      when(
        () => repository.authStatus(),
      ).thenAnswer((_) => const Stream.empty());

      await authUseCase.signInWithEmail(
        email: 'user@example.com',
        password: 'pw123456',
      );
      await authUseCase.signUpWithEmail(
        email: 'new@example.com',
        password: 'pw123456',
        username: 'tester',
      );
      await authUseCase.signOut();
      await authUseCase.deleteAccount();
      await authUseCase.updateProfile(bio: 'bio', avatarUrl: 'avatar.png');
      await expectLater(authUseCase.observeAuthState(), emitsDone);

      verify(
        () => repository.signInWithEmail(
          email: 'user@example.com',
          password: 'pw123456',
        ),
      ).called(1);
      verify(
        () => repository.signUpWithEmail(
          email: 'new@example.com',
          password: 'pw123456',
          username: 'tester',
        ),
      ).called(1);
      verify(() => repository.signOut()).called(1);
      verify(() => repository.deleteAccount()).called(1);
      verify(
        () => repository.updateProfile(bio: 'bio', avatarUrl: 'avatar.png'),
      ).called(1);
      verify(() => repository.authStatus()).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
