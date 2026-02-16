import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:feature_auth/src/domain/entity/auth_user.dart';
import 'package:feature_auth/src/domain/repository/auth_repository.dart';
import 'package:feature_auth/src/domain/usecase/auth_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import 'package:feature_auth/src/core/constants/auth_status.dart';

part 'auth_state.dart';

part 'auth_event.dart';

part 'auth_bloc.freezed.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase _authUseCase;
  StreamSubscription<AuthStreamPayload>? _subscription;

  AuthBloc(this._authUseCase) : super(const AuthState.unKnown()) {
    on<AuthEvent>(_onEvent, transformer: restartable());
  }

  Future<void> _onEvent(AuthEvent event, Emitter<AuthState> emit) async {
    await event.when(
      started: () async {
        await _subscription?.cancel();
        _subscription = _authUseCase.observeAuthState.call().listen((data) {
          final authUser = data.user;
          if (authUser != null && data.status == AuthStatus.authenticated) {
            add(AuthEvent.onAuthenticated(authUser));
          } else {
            add(const AuthEvent.onUnAuthenticated());
          }
        });
      },
      onAuthenticated: (AuthUser authUser) {
        emit(AuthState.authenticated(authUser));
      },
      onUnAuthenticated: () {
        emit(AuthState.unAuthenticated());
      },
    );
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
