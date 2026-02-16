import 'package:feature_auth/src/data/model/auth_user_model.dart';
import 'package:feature_auth/src/data/model/profile_model.dart';
import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/entity/profile.dart';

final DateTime fixedNow = DateTime(2024, 1, 1, 12, 0, 0);

AuthUserModel buildAuthUserModel({
  String id = 'user_1',
  String? email = 'user@example.com',
  String? phone,
  DateTime? createdAt,
  DateTime? updatedAt,
  Map<String, dynamic> userMetadata = const {'role': 'member'},
}) {
  return AuthUserModel(
    id: id,
    email: email,
    phone: phone,
    createdAt: createdAt ?? fixedNow,
    updatedAt: updatedAt ?? fixedNow,
    userMetadata: userMetadata,
  );
}

AuthUser buildAuthUser({
  String id = 'user_1',
  String? email = 'user@example.com',
  String? phone,
  DateTime? createdAt,
  DateTime? updatedAt,
  Map<String, dynamic> userMetadata = const {'role': 'member'},
}) {
  return AuthUser(
    id: id,
    email: email,
    phone: phone,
    createdAt: createdAt ?? fixedNow,
    updatedAt: updatedAt ?? fixedNow,
    userMetadata: userMetadata,
  );
}

ProfileModel buildProfileModel({
  String id = 'user_1',
  String username = 'tester',
  String? avatarUrl,
  String? bio,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return ProfileModel(
    id: id,
    username: username,
    avatarUrl: avatarUrl,
    bio: bio,
    createdAt: createdAt ?? fixedNow,
    updatedAt: updatedAt ?? fixedNow,
  );
}

Profile buildProfile({
  String id = 'user_1',
  String username = 'tester',
  String? avatarUrl,
  String? bio,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return Profile(
    id: id,
    username: username,
    avatarUrl: avatarUrl,
    bio: bio,
    createdAt: createdAt ?? fixedNow,
    updatedAt: updatedAt ?? fixedNow,
  );
}
