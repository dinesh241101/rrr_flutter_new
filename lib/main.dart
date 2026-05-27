import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/app.dart';
import 'package:rrr_flutter_new/core/supabase_client.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  try {
    await SupabaseClientManager.initialize();
  } catch (e) {
    debugPrint('Failed to initialize Supabase: $e');
  }

  // Initialize Ads
  await AdsService.instance.initialize();

  runApp(const RunRewardRiftApp());
}
