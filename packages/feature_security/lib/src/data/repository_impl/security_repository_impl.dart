import 'package:injectable/injectable.dart';

import 'package:feature_security/src/core/errors/security_failure.dart';
import 'package:feature_security/src/core/errors/security_failure_mapper.dart';
import 'package:feature_security/src/data/datasource/security_datasource.dart';
import 'package:feature_security/src/domain/repository/security_repository.dart';
import 'package:fpdart/fpdart.dart';

@LazySingleton(as: SecurityRepository)
class SecurityRepositoryImpl implements SecurityRepository {
  SecurityRepositoryImpl(this._dataSource);

  final SecurityDataSource _dataSource;

  @override
  Future<Either<SecurityFailure, void>> savePassword(String password) async {
    try {
      await _dataSource.savePassword(password);
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toSecurityFailure(stackTrace));
    }
  }

  @override
  Future<Either<SecurityFailure, void>> savePasswordHint(String hint) async {
    try {
      await _dataSource.savePasswordHint(hint);
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toSecurityFailure(stackTrace));
    }
  }

  @override
  Future<Either<SecurityFailure, bool>> verifyPassword(String password) async {
    try {
      final matched = await _dataSource.verifyPassword(password);
      return Right(matched);
    } catch (error, stackTrace) {
      return Left(error.toSecurityFailure(stackTrace));
    }
  }

  @override
  Future<Either<SecurityFailure, String?>> getPasswordHint() async {
    try {
      final hint = await _dataSource.getPasswordHint();
      return Right(hint);
    } catch (error, stackTrace) {
      return Left(error.toSecurityFailure(stackTrace));
    }
  }

  @override
  Future<Either<SecurityFailure, void>> deletePasswordHint() async {
    try {
      await _dataSource.deletePasswordHint();
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toSecurityFailure(stackTrace));
    }
  }

  @override
  Future<Either<SecurityFailure, void>> deletePassword() async {
    try {
      await _dataSource.deletePassword();
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toSecurityFailure(stackTrace));
    }
  }

  @override
  Future<Either<SecurityFailure, bool>> hasPassword() async {
    try {
      final hasPassword = await _dataSource.hasPassword();
      return Right(hasPassword);
    } catch (error, stackTrace) {
      return Left(error.toSecurityFailure(stackTrace));
    }
  }
}
