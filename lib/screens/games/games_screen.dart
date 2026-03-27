import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/data/mock_games.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/games/game_play_screen.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/widgets/featured_game_card.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  Future<void> _watchRewardedForExtraChance(BuildContext context) async {
    final int? reward = await AdsService.instance.showRewarded(
      placement: 'games_extra_chance',
      rewardCoins: AppValues.rewardedAdBonusCoins,
    );
    if (!context.mounted || reward == null) {
      return;
    }
    context.read<WalletProvider>().addCoins(
      amount: reward,
      source: 'Rewarded Ad Bonus',
    );
    context.read<SessionProvider>().trackAdSeen();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Bonus unlocked. +$reward coins.')));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Need extra coins? Watch rewarded ads to boost game rewards.',
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => _watchRewardedForExtraChance(context),
                  child: const Text('Watch'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...MockGames.all.map(
          (game) => FeaturedGameCard(
            game: game,
            onPlay: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => GamePlayScreen(game: game),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
