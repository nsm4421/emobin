import 'package:feature_auth/src/domain/repository/auth_repository.dart';
import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUseCase {
  final AuthRepository _repository;

  const SignOutUseCase(this._repository);

  Future<Either<AuthFailure, void>> call() => _repository.signOut();
}
