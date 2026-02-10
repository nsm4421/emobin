import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../env/env.dart';

@module
abstract class SupabaseModule {
  bool _isInitialized = false;

  @preResolve
  Future<SupabaseClient> get supabase async {
    if (!_isInitialized) {
      await Supabase.initialize(
        url: Env.supabaseProjectUrl,
        anonKey: Env.supabasePublishableKey,
      );
      _isInitialized = true;
    }
    return Supabase.instance.client;
  }
}
