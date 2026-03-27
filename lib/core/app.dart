import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_strings.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/data/mock_quiz.dart';
import 'package:rrr_flutter_new/providers/navigation_provider.dart';
import 'package:rrr_flutter_new/providers/quiz_provider.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/tournament_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/splash_screen.dart';
import 'package:rrr_flutter_new/services/anti_cheat_service.dart';
import 'package:rrr_flutter_new/services/leaderboard_service.dart';
import 'package:rrr_flutter_new/services/wallet_sync_service.dart';

class RunRewardRiftApp extends StatelessWidget {
  const RunRewardRiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => WalletProvider(
                initialCoins: AppValues.initialCoins,
                syncService: MockWalletSyncService(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(questions: MockQuizData.questions),
        ),
        ChangeNotifierProvider(
          create:
              (_) => TournamentProvider(
                leaderboardService: MockLeaderboardService(),
                antiCheatService: AntiCheatService(),
              ),
        ),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
