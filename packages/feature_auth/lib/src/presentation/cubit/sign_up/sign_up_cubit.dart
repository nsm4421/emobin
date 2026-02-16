import 'package:feature_auth/src/core/errors/auth_failure.dart';
import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/usecase/auth_use_case.dart';
import 'package:feature_auth/src/domain/usecase/scenario/sign_up_with_email_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_up_state.dart';

part 'sign_up_cubit.freezed.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  late final SignUpWithEmailUseCase _useCase;

  SignUpCubit(AuthUseCase authUseCases) : super(const SignUpState.initial()) {
    _useCase = authUseCases.signUpWithEmail;
  }

  Future<void> submit({
    required String username,
    required String email,
    required String password,
  }) async {
    emit(const SignUpState.loading());
    await _useCase
        .call(email: email, password: password, username: username)
        .then(
          (res) => res.fold(
            (failure) => emit(SignUpState.failure(failure)),
            (user) => emit(SignUpState.success(user)),
          ),
        );
  }

  void reset() {
    emit(const SignUpState.initial());
  }
}
