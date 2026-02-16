import 'package:feature_auth/src/core/constants/auth_status.dart';
import 'package:feature_auth/src/data/model/auth_user_model.dart';
import 'package:feature_auth/src/data/model/profile_model.dart';

abstract interface class AuthDataSource {
  Stream<DataSourceAuthStreamPayload> authStatus();

  Future<AuthUserModel> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  });

  Future<AuthUserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> deleteAccount();

  Future<ProfileModel> updateProfile({String? bio, String? avatarUrl});
}

typedef DataSourceAuthStreamPayload = ({
  AuthStatus status,
  AuthUserModel? user,
});
