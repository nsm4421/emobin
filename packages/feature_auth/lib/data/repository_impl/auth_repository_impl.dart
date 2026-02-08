import 'package:injectable/injectable.dart';

import 'package:feature_auth/data/datasource/auth_datasource.dart';
import 'package:feature_auth/data/mapper/auth_user_mapper.dart';
import 'package:feature_auth/data/mapper/profile_mapper.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/entity/profile.dart';
import 'package:feature_auth/domain/repository/auth_repository.dart';

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
  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    final model = await _dataSource.signUpWithEmail(
      email: email,
      password: password,
    );
    return model.toEntity();
  }

  @override
  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final model = await _dataSource.signInWithEmail(
      email: email,
      password: password,
    );
    return model.toEntity();
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<void> deleteAccount() {
    return _dataSource.deleteAccount();
  }

  @override
  Future<Profile> updateProfile({String? bio, String? avatarUrl}) async {
    final model = await _dataSource.updateProfile(
      bio: bio,
      avatarUrl: avatarUrl,
    );
    return model.toEntity();
  }
}
