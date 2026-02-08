import 'package:feature_auth/core/constants/auth_status.dart';
import 'package:feature_auth/core/errors/auth_failure.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/entity/profile.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Stream<AuthStreamPayload> authStatus();

  Future<Either<AuthFailure, AuthUser>> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, AuthUser>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, void>> signOut();

  Future<Either<AuthFailure, void>> deleteAccount();

  Future<Either<AuthFailure, Profile>> updateProfile({
    String? bio,
    String? avatarUrl,
  });
}

typedef AuthStreamPayload = ({AuthStatus status, AuthUser? user});
