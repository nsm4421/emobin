import 'package:feature_security/src/core/errors/security_failure.dart';
import 'package:feature_security/src/domain/repository/security_repository.dart';
import 'package:fpdart/fpdart.dart';

class SaveLocalPasswordUseCase {
  const SaveLocalPasswordUseCase(this._repository);

  final SecurityRepository _repository;

  Future<Either<SecurityFailure, void>> call(String password) {
    return _repository.savePassword(password);
  }
}
