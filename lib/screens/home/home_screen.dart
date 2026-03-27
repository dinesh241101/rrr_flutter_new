import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/data/mock_games.dart';
import 'package:rrr_flutter_new/providers/navigation_provider.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/games/game_play_screen.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/widgets/featured_game_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _showRewardedAd(BuildContext context) async {
    final int? reward = await AdsService.instance.showRewarded(
      placement: 'home_bonus',
      rewardCoins: AppValues.rewardedAdBonusCoins,
    );
    if (!context.mounted || reward == null) {
      return;
    }
    context.read<WalletProvider>().addCoins(
      amount: reward,
      source: 'Rewarded Ad',
    );
    context.read<SessionProvider>().trackAdSeen();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rewarded ad complete. +$reward coins added.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WalletProvider, SessionProvider>(
      builder: (BuildContext context, WalletProvider wallet, SessionProvider session, _) {
        final int sessionMinutes = session.sessionDuration.inMinutes;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, player',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Coins: ${wallet.coins}'),
                    Text('Ads watched this session: ${session.adsSeenThisSession}'),
                    Text('Session time: ${sessionMinutes}m'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Watch a rewarded ad for instant bonus coins.',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => _showRewardedAd(context),
                      child: const Text('Watch'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Featured Games',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            FeaturedGameCard(
              game: MockGames.all.first,
              onPlay: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => GamePlayScreen(game: MockGames.all.first),
                  ),
                );
              },
            ),
            FeaturedGameCard(
              game: MockGames.all[1],
              onPlay: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => GamePlayScreen(game: MockGames.all[1]),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Quick Navigate',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => context.read<NavigationProvider>().setTab(1),
                  icon: const Icon(Icons.sports_esports),
                  label: const Text('Games'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.read<NavigationProvider>().setTab(2),
                  icon: const Icon(Icons.emoji_events),
                  label: const Text('Tournament'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.read<NavigationProvider>().setTab(3),
                  icon: const Icon(Icons.quiz),
                  label: const Text('Quizistan'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
