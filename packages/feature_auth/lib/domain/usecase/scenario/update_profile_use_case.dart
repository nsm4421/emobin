import 'package:feature_auth/domain/entity/profile.dart';
import 'package:feature_auth/domain/repository/auth_repository.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Profile> call({String? bio, String? avatarUrl}) {
    return _repository.updateProfile(bio: bio, avatarUrl: avatarUrl);
  }
}
