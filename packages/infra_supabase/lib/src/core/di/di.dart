import 'package:infra_supabase/src/core/env/env.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@InjectableInit.microPackage()
Future<void> initInfraSupabasePackage() async {
  await Supabase.initialize(
    url: Env.supabaseProjectUrl,
    anonKey: Env.supabasePublishableKey,
  );
}
