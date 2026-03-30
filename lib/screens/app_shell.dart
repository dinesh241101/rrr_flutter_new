import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_assets.dart';
import 'package:rrr_flutter_new/core/constants/app_strings.dart';
import 'package:rrr_flutter_new/providers/navigation_provider.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/games/games_screen.dart';
import 'package:rrr_flutter_new/screens/home/home_screen.dart';
import 'package:rrr_flutter_new/screens/quizistan/quizistan_screen.dart';
import 'package:rrr_flutter_new/screens/tournament/tournament_screen.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/services/notifications_service.dart';
import 'package:rrr_flutter_new/widgets/app_drawer.dart';
import 'package:rrr_flutter_new/widgets/coin_balance_chip.dart';
import 'package:rrr_flutter_new/widgets/daily_bonus_dialog.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final NotificationsService _notificationsService = NotificationsService();
  int _tabTransitionCount = 0;
  bool _bootstrapped = false;

  static const List<Widget> _tabs = <Widget>[
    HomeScreen(),
    GamesScreen(),
    TournamentScreen(),
    QuizistanScreen(),
  ];

  static const List<String> _titles = <String>[
    AppStrings.homeTitle,
    AppStrings.gamesTitle,
    AppStrings.tournamentTitle,
    AppStrings.quizistanTitle,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrapSession();
    });
  }

  Future<void> _bootstrapSession() async {
    if (_bootstrapped || !mounted) {
      return;
    }
    _bootstrapped = true;

    final bool appOpenShown = await AdsService.instance.showAppOpenIfAvailable(
      placement: 'app_open_bootstrap',
    );
    if (mounted && appOpenShown) {
      context.read<SessionProvider>().trackAdSeen();
    }

    await _notificationsService.initialize();
    await _notificationsService.scheduleDailyReminder();
    if (!mounted) {
      return;
    }
    await _showDailyBonusIfNeeded();
  }

  Future<void> _showDailyBonusIfNeeded() async {
    final SessionProvider session = context.read<SessionProvider>();
    if (session.dailyBonusClaimed) {
      return;
    }

    final int bonus = session.claimDailyBonus();
    context.read<WalletProvider>().addCoins(
      amount: bonus,
      source: 'Daily Bonus',
    );

    await showDialog<void>(
      context: context,
      builder: (_) => const DailyBonusDialog(),
    );
  }

  Future<void> _onTabSelected(int index) async {
    final NavigationProvider nav = context.read<NavigationProvider>();
    if (nav.currentTab == index) {
      return;
    }
    nav.setTab(index);

    _tabTransitionCount += 1;
    if (_tabTransitionCount % 2 != 0) {
      return;
    }

    final bool shown = await AdsService.instance.showInterstitial(
      placement: 'screen_transition',
    );
    if (!mounted || !shown) {
      return;
    }
    context.read<SessionProvider>().trackAdSeen();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NavigationProvider, WalletProvider>(
      builder:
          (
            BuildContext context,
            NavigationProvider nav,
            WalletProvider wallet,
            _,
          ) {
            return Scaffold(
              drawer: const AppDrawer(),
              appBar: AppBar(
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    AppAssets.appLogo,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.sports_esports),
                  ),
                ),
                title: Text(_titles[nav.currentTab]),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: CoinBalanceChip(coins: wallet.coins),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle),
                    onPressed: () {},
                  ),
                ],
              ),
              body: IndexedStack(index: nav.currentTab, children: _tabs),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: nav.currentTab,
                onTap: _onTabSelected,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.sports_esports),
                    label: 'Games',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.emoji_events),
                    label: 'Tournament',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.quiz),
                    label: 'Quizistan',
                  ),
                ],
              ),
            );
          },
    );
  }
}
