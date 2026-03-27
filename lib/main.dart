import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/app.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdsService.instance.initialize();
  runApp(const RunRewardRiftApp());
}
