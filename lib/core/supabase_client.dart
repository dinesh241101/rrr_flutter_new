import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientManager {
  static late SupabaseClient _client;


// QA
  static const String _supabaseUrl =
      'https://xbbxhkemzrmdsyyclgya.supabase.co';
  static const String _supabaseAnonKey =
      'sb_publishable_fTjFumSU_n7cDxB8wrORpw_J9S10QP_';

  // Prod
  // static const String _supabaseUrl = 'https://ymbugbyfcfmzzxjdjler.supabase.co';
  // static const String _supabaseAnonKey = 'sb_publishable_MkR_GLKKZqnQYNsGFkmuSQ_SsW7__58';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: _supabaseUrl,
      anonKey: _supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client => _client;
  static String get userId => _client.auth.currentUser?.id ?? '';
  static bool get isAuthenticated => _client.auth.currentUser != null;
}
