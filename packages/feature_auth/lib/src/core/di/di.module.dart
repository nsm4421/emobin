//@GeneratedMicroModule;FeatureAuthPackageModule;package:feature_auth/src/core/di/di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:feature_auth/src/data/datasource/auth_datasource.dart' as _i693;
import 'package:feature_auth/src/data/repository_impl/auth_repository_impl.dart'
    as _i889;
import 'package:feature_auth/src/domain/repository/auth_repository.dart'
    as _i1028;
import 'package:feature_auth/src/domain/usecase/auth_use_case.dart' as _i609;
import 'package:feature_auth/src/domain/usecase/scenario/observe_auth_state_use_case.dart'
    as _i820;
import 'package:feature_auth/src/presentation/bloc/auth/auth_bloc.dart'
    as _i558;
import 'package:feature_auth/src/presentation/cubit/sign_in/sign_in_cubit.dart'
    as _i419;
import 'package:feature_auth/src/presentation/cubit/sign_up/sign_up_cubit.dart'
    as _i720;
import 'package:injectable/injectable.dart' as _i526;

class FeatureAuthPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i1028.AuthRepository>(
        () => _i889.AuthRepositoryImpl(gh<_i693.AuthDataSource>()));
    gh.lazySingleton<_i609.AuthUseCase>(
        () => _i609.AuthUseCase(gh<_i1028.AuthRepository>()));
    gh.factory<_i820.ObserveAuthStateUseCase>(
        () => _i820.ObserveAuthStateUseCase(gh<_i1028.AuthRepository>()));
    gh.factory<_i419.SignInCubit>(
        () => _i419.SignInCubit(gh<_i609.AuthUseCase>()));
    gh.factory<_i720.SignUpCubit>(
        () => _i720.SignUpCubit(gh<_i609.AuthUseCase>()));
    gh.lazySingleton<_i558.AuthBloc>(
        () => _i558.AuthBloc(gh<_i609.AuthUseCase>()));
  }
}
