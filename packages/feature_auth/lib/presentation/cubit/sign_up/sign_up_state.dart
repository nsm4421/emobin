part of 'sign_up_cubit.dart';

@freezed
class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = _SignUpInitial;

  const factory SignUpState.loading() = _SignUpLoading;

  const factory SignUpState.success(AuthUser user) = _SignUpSuccess;

  const factory SignUpState.failure(AuthFailure failure) = _SignUpFailure;
}
