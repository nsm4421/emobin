import 'package:feature_auth/data/model/auth_user_model.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';

extension AuthUserModelX on AuthUserModel {
  AuthUser toEntity() {
    return AuthUser(
      id: id,
      email: email,
      phone: phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userMetadata: userMetadata,
    );
  }
}

extension AuthUserX on AuthUser {
  AuthUserModel toModel() {
    return AuthUserModel(
      id: id,
      email: email,
      phone: phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userMetadata: userMetadata,
    );
  }
}
