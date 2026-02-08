import 'package:feature_auth/core/constants/auth_status.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/entity/profile.dart';

abstract class AuthRepository {
  Stream<AuthStreamPayload> authStatus();

  Future<AuthUser> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<AuthUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> deleteAccount();

  Future<Profile> updateProfile({String? bio, String? avatarUrl});
}

typedef AuthStreamPayload = ({AuthStatus status, AuthUser? user});
