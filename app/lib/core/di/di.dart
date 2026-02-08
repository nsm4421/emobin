import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:feature_auth/feature_auth.dart';

import 'di.config.dart';

@InjectableInit(
  preferRelativeImports: true,
  includeMicroPackages: true,
  externalPackageModulesBefore: [ExternalModule(FeatureAuthPackageModule)],
)
void configureDependencies() => GetIt.instance.init();
