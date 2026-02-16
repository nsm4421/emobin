import 'package:feature_security/src/core/errors/security_failure.dart';
import 'package:feature_security/src/domain/repository/security_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteLocalPasswordUseCase {
  const DeleteLocalPasswordUseCase(this._repository);

  final SecurityRepository _repository;

  Future<Either<SecurityFailure, void>> call() {
    return _repository.deletePassword();
  }
}
