import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/providers/tournament_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({super.key});

  static const String _localPlayerId = 'local_device_player';
  static const String _localPlayerName = 'You';

  Future<void> _joinTournament(BuildContext context) async {
    final TournamentProvider tournament = context.read<TournamentProvider>();
    final WalletProvider wallet = context.read<WalletProvider>();

    if (tournament.joined) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Already joined this round.')));
      return;
    }

    final bool paid = wallet.spendCoins(
      amount: tournament.entryFee,
      source: 'Tournament entry',
    );
    if (!paid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins for tournament entry.')),
      );
      return;
    }

    tournament.markJoined();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Entry confirmed. ${tournament.entryFee} coins deducted.')),
    );
  }

  Future<void> _submitMockScore(BuildContext context) async {
    final TournamentProvider tournament = context.read<TournamentProvider>();
    final int score = 600 + Random().nextInt(2600);
    final String? error = await tournament.submitScore(
      playerId: _localPlayerId,
      playerName: _localPlayerName,
      score: score,
    );

    if (!context.mounted) {
      return;
    }
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Score submitted: $score')));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TournamentProvider>(
      builder: (BuildContext context, TournamentProvider tournament, _) {
        return RefreshIndicator(
          onRefresh: tournament.loadLeaderboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prize Pool: ${tournament.prizePool} coins',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('Entry Fee: ${tournament.entryFee} coins'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () => _joinTournament(context),
                              child: Text(
                                tournament.joined
                                    ? 'Joined'
                                    : 'Join Tournament',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed:
                                  tournament.isSubmitting
                                      ? null
                                      : () => _submitMockScore(context),
                              child: Text(
                                tournament.isSubmitting
                                    ? 'Submitting...'
                                    : 'Submit Score',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Leaderboard (Top 50)',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              if (tournament.isLoading && tournament.entries.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                ...tournament.entries.map(
                  (entry) => Card(
                    child: ListTile(
                      dense: true,
                      leading: CircleAvatar(child: Text('${entry.rank}')),
                      title: Text(entry.playerName),
                      trailing: Text(
                        '${entry.score}',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
