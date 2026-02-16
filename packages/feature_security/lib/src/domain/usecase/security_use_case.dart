import 'package:injectable/injectable.dart';

import 'package:feature_security/src/domain/repository/security_repository.dart';
import 'package:feature_security/src/domain/usecase/scenario/delete_local_password_use_case.dart';
import 'package:feature_security/src/domain/usecase/scenario/has_local_password_use_case.dart';
import 'package:feature_security/src/domain/usecase/scenario/save_local_password_use_case.dart';
import 'package:feature_security/src/domain/usecase/scenario/verify_local_password_use_case.dart';

@lazySingleton
class SecurityUseCase {
  SecurityUseCase(this._repository);

  final SecurityRepository _repository;

  SaveLocalPasswordUseCase get saveLocalPassword =>
      SaveLocalPasswordUseCase(_repository);

  VerifyLocalPasswordUseCase get verifyLocalPassword =>
      VerifyLocalPasswordUseCase(_repository);

  DeleteLocalPasswordUseCase get deleteLocalPassword =>
      DeleteLocalPasswordUseCase(_repository);

  HasLocalPasswordUseCase get hasLocalPassword =>
      HasLocalPasswordUseCase(_repository);
}
