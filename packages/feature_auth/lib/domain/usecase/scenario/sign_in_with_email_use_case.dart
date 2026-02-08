import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/repository/auth_repository.dart';
import 'package:feature_auth/core/errors/auth_failure.dart';
import 'package:fpdart/fpdart.dart';

class SignInWithEmailUseCase {
  final AuthRepository _repository;

  const SignInWithEmailUseCase(this._repository);

  Future<Either<AuthFailure, AuthUser>> call({
    required String email,
    required String password,
  }) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
