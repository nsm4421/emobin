import 'package:feature_auth/src/data/model/profile_model.dart';
import 'package:feature_auth/src/domain/entity/profile.dart';

extension ProfileModelX on ProfileModel {
  Profile toEntity() {
    return Profile(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      bio: bio,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension ProfileX on Profile {
  ProfileModel toModel() {
    return ProfileModel(
      id: id,
      username: username,
      avatarUrl: avatarUrl,
      bio: bio,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
