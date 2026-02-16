import 'package:feature_auth/src/domain/repository/auth_repository.dart';
import 'package:injectable/injectable.dart';

import 'scenario/delete_account_use_case.dart';
import 'scenario/observe_auth_state_use_case.dart';
import 'scenario/sign_out_use_case.dart';
import 'scenario/sign_in_with_email_use_case.dart';
import 'scenario/sign_up_with_email_use_case.dart';
import 'scenario/update_profile_use_case.dart';

@lazySingleton
class AuthUseCase {
  final AuthRepository _repository;

  AuthUseCase(this._repository);

  DeleteAccountUseCase get deleteAccount => DeleteAccountUseCase(_repository);

  ObserveAuthStateUseCase get observeAuthState =>
      ObserveAuthStateUseCase(_repository);

  SignInWithEmailUseCase get signInWithEmail =>
      SignInWithEmailUseCase(_repository);

  SignUpWithEmailUseCase get signUpWithEmail =>
      SignUpWithEmailUseCase(_repository);

  SignOutUseCase get signOut => SignOutUseCase(_repository);

  UpdateProfileUseCase get updateProfile => UpdateProfileUseCase(_repository);
}
