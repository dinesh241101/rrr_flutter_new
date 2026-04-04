import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/data/mock_games.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/games/game_play_screen.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/widgets/featured_game_card.dart';
import 'package:rrr_flutter_new/widgets/game_cards.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  bool _isListView = false;

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
    return Column(
      children: [
        // View Toggle
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(context, mobilePadding: 12),
          ),
          color: const Color(0xFF1A1F3A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ResponsiveSubheading('Available Games'),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isListView = false),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: !_isListView
                              ? Colors.blueAccent
                              : Colors.white12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.dashboard,
                        color: !_isListView
                            ? Colors.blueAccent
                            : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isListView = true),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isListView
                              ? Colors.blueAccent
                              : Colors.white12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.list,
                        color: _isListView ? Colors.blueAccent : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(context),
            ),
            children: [
              Card(
                color: const Color(0xFF1A1F3A),
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
              if (!_isListView)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: MockGames.all.length,
                  itemBuilder: (context, index) {
                    final game = MockGames.all[index];
                    return GameTileCard(
                      game: game,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => GamePlayScreen(game: game),
                          ),
                        );
                      },
                      onPlayPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => GamePlayScreen(game: game),
                          ),
                        );
                      },
                    );
                  },
                )
              else
                Column(
                  children: MockGames.all.map((game) {
                    return GameListCard(
                      game: game,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => GamePlayScreen(game: game),
                          ),
                        );
                      },
                      onPlayPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => GamePlayScreen(game: game),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
