import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/repository/auth_repository.dart';

class SignInWithEmailUseCase {
  final AuthRepository _repository;

  const SignInWithEmailUseCase(this._repository);

  Future<AuthUser> call({required String email, required String password}) {
    return _repository.signInWithEmail(email: email, password: password);
  }
}
