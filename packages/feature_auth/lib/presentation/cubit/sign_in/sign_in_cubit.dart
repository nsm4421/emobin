import 'package:feature_auth/core/errors/auth_failure.dart';
import 'package:feature_auth/domain/entity/auth_user.dart';
import 'package:feature_auth/domain/usecase/auth_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:feature_auth/domain/usecase/scenario/sign_in_with_email_use_case.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'sign_in_state.dart';

part 'sign_in_cubit.freezed.dart';

@lazySingleton
class SignInCubit extends Cubit<SignInState> {
  late final SignInWithEmailUseCase _useCase;

  SignInCubit(AuthUseCase authUseCases) : super(const SignInState.initial()) {
    _useCase = authUseCases.signInWithEmail;
  }

  Future<void> submit({required String email, required String password}) async {
    emit(const SignInState.loading());
    final result = await _useCase.call(email: email, password: password);
    result.fold(
      (failure) => emit(SignInState.failure(failure)),
      (user) => emit(SignInState.success(user)),
    );
  }
}
