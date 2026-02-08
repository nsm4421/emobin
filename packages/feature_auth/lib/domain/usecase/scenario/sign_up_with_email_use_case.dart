import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/repository/auth_repository.dart';

class SignUpWithEmailUseCase {
  final AuthRepository _repository;

  const SignUpWithEmailUseCase(this._repository);

  Future<AuthUser> call({required String email, required String password}) {
    return _repository.signUpWithEmail(email: email, password: password);
  }
}
