import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';
import 'package:rrr_flutter_new/services/games_repository.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class GameScoresScreen extends StatefulWidget {
  final String userId;
  final String? gameId;

  const GameScoresScreen({Key? key, required this.userId, this.gameId})
    : super(key: key);

  @override
  State<GameScoresScreen> createState() => _GameScoresScreenState();
}

class _GameScoresScreenState extends State<GameScoresScreen> {
  late Future<List<GameScore>> _scoresFuture;

  @override
  void initState() {
    super.initState();
    _scoresFuture = GamesRepository.getUserGameScores(
      widget.userId,
      limit: 100,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const ResponsiveHeading('Game Scores'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A1F3A),
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder<List<GameScore>>(
          future: _scoresFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00F0FF)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: ResponsiveBody('Error loading scores'));
            }

            final scores = snapshot.data ?? [];

            if (scores.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.videogame_asset,
                      size: 64,
                      color: Colors.white30,
                    ),
                    const SizedBox(height: 16),
                    const ResponsiveBody(
                      'No game scores yet',
                      color: Colors.white70,
                    ),
                  ],
                ),
              );
            }

            // Group scores by game
            final groupedScores = <String, List<GameScore>>{};
            for (var score in scores) {
              groupedScores.putIfAbsent(score.gameName, () => []).add(score);
            }

            return ListView.builder(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(context),
              ),
              itemCount: groupedScores.entries.length,
              itemBuilder: (context, index) {
                final entry = groupedScores.entries.elementAt(index);
                return _buildGameScoreSection(context, entry.key, entry.value);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameScoreSection(
    BuildContext context,
    String gameName,
    List<GameScore> scores,
  ) {
    final bestScore = scores.reduce((a, b) => a.score > b.score ? a : b);
    final averageScore =
        (scores.fold<int>(0, (sum, score) => sum + score.score) / scores.length)
            .toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 12, top: 12),
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(context, mobilePadding: 12),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF00F0FF).withOpacity(0.2),
                const Color(0xFFBD00FF).withOpacity(0.2),
              ],
            ),
            border: Border.all(color: const Color(0xFF00F0FF), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveSubheading(gameName),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard(
                    context,
                    'Best',
                    bestScore.score.toString(),
                    const Color(0xFFFFD700),
                  ),
                  _buildStatCard(
                    context,
                    'Average',
                    averageScore.toString(),
                    const Color(0xFF00F0FF),
                  ),
                  _buildStatCard(
                    context,
                    'Total',
                    scores.length.toString(),
                    const Color(0xFF39FF14),
                  ),
                ],
              ),
            ],
          ),
        ),
        ...scores.take(3).map((score) => _buildScoreCard(context, score)),
        if (scores.length > 3)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ResponsiveCaption('and ${scores.length - 3} more scores'),
            ),
          ),
        const Divider(color: Colors.white12, height: 24),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        ResponsiveCaption(label, color: Colors.white70),
        const SizedBox(height: 4),
        ResponsiveSubheading(value, color: color),
      ],
    );
  }

  Widget _buildScoreCard(BuildContext context, GameScore score) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(context, mobilePadding: 12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12, width: 1),
        color: Colors.white.withOpacity(0.02),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveBody('Score: ${score.score}'),
              if (score.timeTaken != null)
                ResponsiveCaption(
                  'Time: ${(score.timeTaken! / 1000).toStringAsFixed(1)}s',
                ),
            ],
          ),
          ResponsiveCaption('${score.createdAt.month}/${score.createdAt.day}'),
        ],
      ),
    );
  }
}
