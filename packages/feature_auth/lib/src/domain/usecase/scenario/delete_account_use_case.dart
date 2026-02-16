import 'package:feature_auth/src/domain/repository/auth_repository.dart';
import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccountUseCase {
  final AuthRepository _repository;

  const DeleteAccountUseCase(this._repository);

  Future<Either<AuthFailure, void>> call() => _repository.deleteAccount();
}
