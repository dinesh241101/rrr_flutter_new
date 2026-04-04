import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/providers/tournament_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';

// Neon Color Palette
class NeonColors {
  static const Color cyan = Color(0xFF00F0FF);
  static const Color magenta = Color(0xFFFF006E);
  static const Color lime = Color(0xFF39FF14);
  static const Color purple = Color(0xFFBD00FF);
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color cardBg = Color(0xFF1A1F3A);
  static const Color borderGlow = Color(0xFF00F0FF);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color gold = Color(0xFFFFD700);
}

class TournamentScreen extends StatefulWidget {
  const TournamentScreen({super.key});

  static const String _localPlayerId = 'local_device_player';
  static const String _localPlayerName = 'You';

  @override
  State<TournamentScreen> createState() => _TournamentScreenState();
}

class _TournamentScreenState extends State<TournamentScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _joinTournament(BuildContext context) async {
    final TournamentProvider tournament = context.read<TournamentProvider>();
    final WalletProvider wallet = context.read<WalletProvider>();

    if (tournament.joined) {
      _showNeonSnackBar(context, 'Already joined this round.', NeonColors.cyan);
      return;
    }

    final bool paid = wallet.spendCoins(
      amount: tournament.entryFee,
      source: 'Tournament entry',
    );
    if (!paid) {
      _showNeonSnackBar(
        context,
        'Not enough coins for tournament entry.',
        NeonColors.magenta,
      );
      return;
    }

    tournament.markJoined();
    _showNeonSnackBar(
      context,
      'Entry confirmed. ${tournament.entryFee} coins deducted.',
      NeonColors.lime,
    );
  }

  Future<void> _submitMockScore(BuildContext context) async {
    final TournamentProvider tournament = context.read<TournamentProvider>();
    final int score = 600 + Random().nextInt(2600);
    final String? error = await tournament.submitScore(
      playerId: TournamentScreen._localPlayerId,
      playerName: TournamentScreen._localPlayerName,
      score: score,
    );

    if (!context.mounted) {
      return;
    }
    if (error != null) {
      _showNeonSnackBar(context, error, NeonColors.magenta);
      return;
    }

    _showNeonSnackBar(context, 'Score submitted: $score', NeonColors.lime);
  }

  void _showNeonSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: color.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 1.5),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            NeonColors.darkBg,
            NeonColors.darkBg.withOpacity(0.8),
            const Color(0xFF0F1535),
          ],
        ),
      ),
      child: Consumer<TournamentProvider>(
        builder: (BuildContext context, TournamentProvider tournament, _) {
          return RefreshIndicator(
            onRefresh: tournament.loadLeaderboard,
            color: NeonColors.cyan,
            backgroundColor: NeonColors.cardBg,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header with Prize Pool
                _buildHeaderCard(tournament, context),
                const SizedBox(height: 24),
                // Leaderboard Title
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [NeonColors.cyan, NeonColors.lime],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Leaderboard',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: NeonColors.cyan,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(Top ${tournament.entries.length})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: NeonColors.cyan.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Leaderboard Content
                if (tournament.isLoading && tournament.entries.isEmpty)
                  _buildLoadingState()
                else if (tournament.entries.isEmpty)
                  _buildEmptyState(context)
                else
                  ..._buildLeaderboardEntries(tournament, context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard(TournamentProvider tournament, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonColors.cyan.withOpacity(0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: NeonColors.cyan.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: NeonColors.purple.withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  NeonColors.cardBg.withOpacity(0.6),
                  NeonColors.cardBg.withOpacity(0.3),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Prize Pool Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [NeonColors.gold, NeonColors.accentOrange],
                        ),
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PRIZE POOL',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: NeonColors.cyan.withOpacity(0.7),
                                fontSize: 10,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tournament.prizePool}',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: NeonColors.gold,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        Text(
                          'coins',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: NeonColors.gold.withOpacity(0.7),
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: NeonColors.cyan.withOpacity(0.2), height: 1),
                const SizedBox(height: 16),
                // Entry Fee Row
                Row(
                  children: [
                    Text(
                      'Entry Fee',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: NeonColors.lime.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: NeonColors.lime.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${tournament.entryFee} coins',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: NeonColors.lime,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: _buildNeonButton(
                        label: tournament.joined ? 'JOINED' : 'JOIN TOURNAMENT',
                        onPressed: tournament.joined
                            ? null
                            : () => _joinTournament(context),
                        backgroundColor: NeonColors.lime,
                        textColor: Colors.black,
                        isEnabled: !tournament.joined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildNeonButton(
                        label: tournament.isSubmitting
                            ? 'SUBMITTING...'
                            : 'SUBMIT SCORE',
                        onPressed: tournament.isSubmitting
                            ? null
                            : () => _submitMockScore(context),
                        backgroundColor: NeonColors.cyan,
                        textColor: Colors.black,
                        isEnabled: !tournament.isSubmitting,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNeonButton({
    required String label,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color textColor,
    required bool isEnabled,
  }) {
    return Container(
      decoration: isEnabled
          ? BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            )
          : BoxDecoration(
              color: backgroundColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isEnabled ? textColor : textColor.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: _pulseController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    NeonColors.cyan.withOpacity(0.3),
                    NeonColors.purple.withOpacity(0.3),
                  ],
                ),
                border: Border.all(color: NeonColors.cyan, width: 2),
              ),
              child: SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(NeonColors.cyan),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Tournament Data',
            style: TextStyle(
              color: NeonColors.cyan.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(
            Icons.leaderboard_outlined,
            size: 64,
            color: NeonColors.cyan.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No Scores Yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: NeonColors.cyan.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Be the first to submit a score!',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white38),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildLeaderboardEntries(
    TournamentProvider tournament,
    BuildContext context,
  ) {
    return tournament.entries.asMap().entries.map((mapEntry) {
      int index = mapEntry.key;
      var entry = mapEntry.value;

      // Medal colors for top 3
      Color medalColor = Colors.grey;
      if (entry.rank == 1) {
        medalColor = NeonColors.gold;
      } else if (entry.rank == 2) {
        medalColor = const Color(0xFFC0C0C0);
      } else if (entry.rank == 3) {
        medalColor = const Color(0xFFCD7F32);
      }

      // Highlight color based on rank
      Color highlightColor = entry.rank == 1
          ? NeonColors.gold.withOpacity(0.15)
          : entry.rank == 2
          ? NeonColors.cyan.withOpacity(0.1)
          : entry.rank == 3
          ? NeonColors.magenta.withOpacity(0.1)
          : Colors.transparent;

      Color borderColor = entry.rank == 1
          ? NeonColors.gold.withOpacity(0.4)
          : entry.rank == 2
          ? NeonColors.cyan.withOpacity(0.3)
          : entry.rank == 3
          ? NeonColors.magenta.withOpacity(0.3)
          : NeonColors.cyan.withOpacity(0.15);

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: entry.rank <= 3
                ? [
                    BoxShadow(
                      color: medalColor.withOpacity(0.15),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      NeonColors.cardBg.withOpacity(0.5),
                      NeonColors.cardBg.withOpacity(0.2),
                    ],
                  ),
                  color: highlightColor != Colors.transparent
                      ? highlightColor
                      : null,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: entry.rank == 1
                          ? LinearGradient(
                              colors: [
                                NeonColors.gold,
                                NeonColors.accentOrange,
                              ],
                            )
                          : entry.rank == 2
                          ? LinearGradient(
                              colors: [
                                NeonColors.cyan,
                                NeonColors.cyan.withOpacity(0.7),
                              ],
                            )
                          : entry.rank == 3
                          ? LinearGradient(
                              colors: [NeonColors.magenta, NeonColors.purple],
                            )
                          : LinearGradient(
                              colors: [
                                NeonColors.purple.withOpacity(0.4),
                                NeonColors.cyan.withOpacity(0.4),
                              ],
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: medalColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '${entry.rank}',
                        style: TextStyle(
                          color: entry.rank <= 3 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    entry.playerName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${entry.score}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: entry.rank == 1
                              ? NeonColors.gold
                              : NeonColors.lime,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'pts',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}
