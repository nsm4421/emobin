import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/repository/auth_repository.dart';
import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:fpdart/fpdart.dart';

class SignUpWithEmailUseCase {
  final AuthRepository _repository;

  const SignUpWithEmailUseCase(this._repository);

  Future<Either<AuthFailure, AuthUser>> call({
    required String email,
    required String password,
    required String username,
  }) {
    return _repository.signUpWithEmail(
      email: email,
      password: password,
      username: username,
    );
  }
}
