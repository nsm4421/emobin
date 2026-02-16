import 'package:injectable/injectable.dart';
import 'package:feature_auth/src/core/constants/auth_status.dart';
import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/repository/auth_repository.dart';

@injectable
class ObserveAuthStateUseCase {
  final AuthRepository _repository;

  const ObserveAuthStateUseCase(this._repository);

  Stream<({AuthStatus status, AuthUser? user})> call() =>
      _repository.authStatus();
}
