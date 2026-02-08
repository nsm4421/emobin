import 'package:feature_auth/domain/repository/auth_repository.dart';
import 'package:feature_auth/core/errors/auth_failure.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccountUseCase {
  final AuthRepository _repository;

  const DeleteAccountUseCase(this._repository);

  Future<Either<AuthFailure, void>> call() => _repository.deleteAccount();
}
