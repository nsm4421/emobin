part of 'sign_in_cubit.dart';

@freezed
class SignInState with _$SignInState {
  const factory SignInState.initial() = _SignInInitial;

  const factory SignInState.loading() = _SignInLoading;

  const factory SignInState.success(AuthUser user) = _SignInSuccess;

  const factory SignInState.failure(AuthFailure failure) = _SignInFailure;
}
