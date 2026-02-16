import 'package:feature_auth/src/domain/entity/profile.dart';
import 'package:feature_auth/src/domain/repository/auth_repository.dart';
import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Either<AuthFailure, Profile>> call({String? bio, String? avatarUrl}) {
    return _repository.updateProfile(bio: bio, avatarUrl: avatarUrl);
  }
}
