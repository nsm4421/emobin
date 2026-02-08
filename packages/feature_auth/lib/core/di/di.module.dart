//@GeneratedMicroModule;FeatureAuthPackageModule;package:feature_auth/core/di/di.module.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i687;

import 'package:feature_auth/data/datasource/auth_datasource.dart' as _i861;
import 'package:feature_auth/data/datasource/mock_auth_datasource.dart'
    as _i634;
import 'package:feature_auth/data/repository_impl/auth_repository_impl.dart'
    as _i437;
import 'package:feature_auth/domain/repository/auth_repository.dart' as _i180;
import 'package:feature_auth/domain/usecase/auth_use_case.dart' as _i814;
import 'package:feature_auth/domain/usecase/scenario/observe_auth_state_use_case.dart'
    as _i357;
import 'package:feature_auth/presentation/bloc/auth/auth_bloc.dart' as _i656;
import 'package:feature_auth/presentation/cubit/sign_in/sign_in_cubit.dart'
    as _i1013;
import 'package:feature_auth/presentation/cubit/sign_up/sign_up_cubit.dart'
    as _i190;
import 'package:injectable/injectable.dart' as _i526;

class FeatureAuthPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    gh.lazySingleton<_i861.AuthDataSource>(() => _i634.MockAuthDataSource());
    gh.lazySingleton<_i180.AuthRepository>(
        () => _i437.AuthRepositoryImpl(gh<_i861.AuthDataSource>()));
    gh.factory<_i357.ObserveAuthStateUseCase>(
        () => _i357.ObserveAuthStateUseCase(gh<_i180.AuthRepository>()));
    gh.lazySingleton<_i814.AuthUseCase>(
        () => _i814.AuthUseCase(gh<_i180.AuthRepository>()));
    gh.lazySingleton<_i1013.SignInCubit>(
        () => _i1013.SignInCubit(gh<_i814.AuthUseCase>()));
    gh.lazySingleton<_i190.SignUpCubit>(
        () => _i190.SignUpCubit(gh<_i814.AuthUseCase>()));
    gh.lazySingleton<_i656.AuthBloc>(
        () => _i656.AuthBloc(gh<_i814.AuthUseCase>()));
  }
}
