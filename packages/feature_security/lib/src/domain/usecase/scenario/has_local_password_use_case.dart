import 'package:feature_security/src/core/errors/security_failure.dart';
import 'package:feature_security/src/domain/repository/security_repository.dart';
import 'package:fpdart/fpdart.dart';

class HasLocalPasswordUseCase {
  const HasLocalPasswordUseCase(this._repository);

  final SecurityRepository _repository;

  Future<Either<SecurityFailure, bool>> call() {
    return _repository.hasPassword();
  }
}
