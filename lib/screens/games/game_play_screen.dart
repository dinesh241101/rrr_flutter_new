import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/models/game_mode.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';

class GamePlayScreen extends StatefulWidget {
  const GamePlayScreen({super.key, required this.game});

  final GameMode game;

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  bool _isPlaying = false;
  int? _lastScore;
  int? _lastReward;

  Future<void> _finishRound() async {
    setState(() {
      _isPlaying = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));
    final Random random = Random();
    final int score = (widget.game.baseReward * 10) + random.nextInt(260);
    final int reward = widget.game.baseReward + (score ~/ 100);

    if (!mounted) {
      return;
    }
    context.read<WalletProvider>().addCoins(
      amount: reward,
      source: '${widget.game.name} reward',
    );

    final bool adShown = await AdsService.instance.showInterstitial(
      placement: 'game_end_${widget.game.id}',
    );
    if (mounted && adShown) {
      context.read<SessionProvider>().trackAdSeen();
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _lastScore = score;
      _lastReward = reward;
      _isPlaying = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Round complete! Score $score, reward +$reward')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.game.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.game.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 18),
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: Text(
                  'Game Surface Placeholder',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_lastScore != null && _lastReward != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Last Round -> Score: $_lastScore | Coins Earned: +$_lastReward',
                  ),
                ),
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isPlaying ? null : _finishRound,
                icon: const Icon(Icons.flag),
                label: Text(_isPlaying ? 'Finishing...' : 'Finish Round'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
