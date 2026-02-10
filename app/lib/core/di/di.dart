import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_feed/feature_feed.dart';
import 'package:infra_supabase/infra_supabase.dart';

import 'di.config.dart';

@InjectableInit(
  preferRelativeImports: true,
  includeMicroPackages: true,
  externalPackageModulesBefore: [
    ExternalModule(FeatureAuthPackageModule),
    ExternalModule(FeatureFeedPackageModule),
    ExternalModule(InfraSupabasePackageModule),
  ],
)
Future<void> configureDependencies() async {
  await initInfraSupabasePackage();
  GetIt.instance.init();
}
