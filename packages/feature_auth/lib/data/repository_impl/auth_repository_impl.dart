import 'package:injectable/injectable.dart';

import 'package:feature_auth/core/errors/auth_failure.dart';
import 'package:feature_auth/core/errors/auth_failure_mapper.dart';
import 'package:feature_auth/data/datasource/auth_datasource.dart';
import 'package:feature_auth/data/mapper/auth_user_mapper.dart';
import 'package:feature_auth/data/mapper/profile_mapper.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/entity/profile.dart';
import 'package:feature_auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Stream<AuthStreamPayload> authStatus() {
    return _dataSource.authStatus().map(
      (state) => (status: state.status, user: state.user?.toEntity()),
    );
  }

  @override
  Future<Either<AuthFailure, AuthUser>> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final model = await _dataSource.signUpWithEmail(
        email: email,
        password: password,
        username: username,
      );
      return Right(model.toEntity());
    } catch (error, stackTrace) {
      return Left(error.toAuthFailure(stackTrace));
    }
  }

  @override
  Future<Either<AuthFailure, AuthUser>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _dataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(model.toEntity());
    } catch (error, stackTrace) {
      return Left(error.toAuthFailure(stackTrace));
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toAuthFailure(stackTrace));
    }
  }

  @override
  Future<Either<AuthFailure, void>> deleteAccount() async {
    try {
      await _dataSource.deleteAccount();
      return const Right(null);
    } catch (error, stackTrace) {
      return Left(error.toAuthFailure(stackTrace));
    }
  }

  @override
  Future<Either<AuthFailure, Profile>> updateProfile({
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final model = await _dataSource.updateProfile(
        bio: bio,
        avatarUrl: avatarUrl,
      );
      return Right(model.toEntity());
    } catch (error, stackTrace) {
      return Left(error.toAuthFailure(stackTrace));
    }
  }
}
