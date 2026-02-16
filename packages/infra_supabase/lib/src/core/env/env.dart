import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env.local')
abstract class Env {
  @EnviedField(varName: 'SUPABASE_PROJECT_URL')
  static const String supabaseProjectUrl = _Env.supabaseProjectUrl;

  @EnviedField(varName: 'SUPABASE_PUBLISHABLE_KEY')
  static const String supabasePublishableKey = _Env.supabasePublishableKey;
}
