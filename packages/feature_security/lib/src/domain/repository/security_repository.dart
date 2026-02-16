import 'package:feature_security/src/core/errors/security_failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SecurityRepository {
  Future<Either<SecurityFailure, void>> savePassword(String password);

  Future<Either<SecurityFailure, bool>> verifyPassword(String password);

  Future<Either<SecurityFailure, void>> deletePassword();

  Future<Either<SecurityFailure, bool>> hasPassword();
}
