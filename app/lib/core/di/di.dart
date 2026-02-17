import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:feature_setting/feature_setting.dart';
import 'package:feature_security/feature_security.dart';
import 'package:infra_drift/infra_drift.dart';
import 'package:infra_supabase/infra_supabase.dart';

import '../bloc/app_bloc_observer.dart';
import 'di.config.dart';

@InjectableInit(
  preferRelativeImports: true,
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(InfraDriftPackageModule),
    ExternalModule(InfraSupabasePackageModule),
    ExternalModule(FeatureAuthPackageModule),
    ExternalModule(FeatureFeedPackageModule),
    ExternalModule(FeatureSecurityPackageModule),
    ExternalModule(FeatureSettingPackageModule),
  ],
)
Future<void> configureDependencies() async {
  await initInfraSupabasePackage();
  await initInfraDriftPackage();
  await initFeatureSettingPackage();
  await GetIt.instance.init();
  Bloc.observer = GetIt.instance<AppBlocObserver>();
}
