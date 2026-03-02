import 'package:feature_security/src/core/errors/security_failure.dart';
import 'package:feature_security/src/domain/repository/security_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteLocalPasswordHintUseCase {
  const DeleteLocalPasswordHintUseCase(this._repository);

  final SecurityRepository _repository;

  Future<Either<SecurityFailure, void>> call() {
    return _repository.deletePasswordHint();
  }
}
