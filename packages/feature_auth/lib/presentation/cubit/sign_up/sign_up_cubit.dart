import 'package:feature_auth/core/errors/auth_failure.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/usecase/auth_use_case.dart';
import 'package:feature_auth/domain/usecase/scenario/sign_up_with_email_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_up_state.dart';

part 'sign_up_cubit.freezed.dart';

@lazySingleton
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
    final result = await _useCase.call(email: email, password: password);
    result.fold(
      (failure) => emit(SignUpState.failure(failure)),
      (user) => emit(SignUpState.success(user)),
    );
  }
}
