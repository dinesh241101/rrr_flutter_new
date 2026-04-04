import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class RewardHistoryScreen extends StatelessWidget {
  const RewardHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading(
          'Reward History',
          color: Colors.white,
        ),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: NeonTheme.rainbowNeonGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: NeonTheme.neonCyan.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveCaption(
                  'Total Rewards Earned',
                  color: Colors.white70,
                ),
                const SizedBox(height: 8),
                ResponsiveHeading('4,250 coins', color: Colors.white),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSummaryStat('Rewards', '24', NeonTheme.neonLime),
                    _buildSummaryStat('This Week', '580', NeonTheme.neonPink),
                    _buildSummaryStat(
                      'This Month',
                      '1,250',
                      NeonTheme.neonCyan,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recent Rewards Header
          ResponsiveSubheading('Recent Rewards', color: NeonTheme.neonCyan),
          const SizedBox(height: 12),

          // Reward Items
          _buildRewardCard(
            title: 'Spin Wheel - Jackpot!',
            coins: 500,
            date: 'Today at 3:45 PM',
            icon: Icons.catching_pokemon,
            color: NeonTheme.neonLime,
          ),
          const SizedBox(height: 12),
          _buildRewardCard(
            title: 'Quiz Completion Bonus',
            coins: 150,
            date: 'Today at 2:30 PM',
            icon: Icons.quiz,
            color: NeonTheme.neonPurple,
          ),
          const SizedBox(height: 12),
          _buildRewardCard(
            title: 'Ad Reward',
            coins: 50,
            date: 'Today at 1:15 PM',
            icon: Icons.play_circle_outline,
            color: NeonTheme.neonPink,
          ),
          const SizedBox(height: 12),
          _buildRewardCard(
            title: 'Tournament Prize - 3rd Place',
            coins: 300,
            date: 'Yesterday at 9:00 PM',
            icon: Icons.emoji_events,
            color: NeonTheme.neonOrange,
          ),
          const SizedBox(height: 12),
          _buildRewardCard(
            title: 'Scratch Card - Premium',
            coins: 200,
            date: 'Yesterday at 4:20 PM',
            icon: Icons.style,
            color: NeonTheme.neonCyan,
          ),
          const SizedBox(height: 12),
          _buildRewardCard(
            title: 'Daily Bonus',
            coins: 100,
            date: '2 days ago',
            icon: Icons.card_giftcard,
            color: NeonTheme.neonLime,
          ),
          const SizedBox(height: 12),
          _buildRewardCard(
            title: 'Game High Score',
            coins: 250,
            date: '3 days ago',
            icon: Icons.sports_esports,
            color: NeonTheme.neonPurple,
          ),
          const SizedBox(height: 12),
          _buildRewardCard(
            title: 'Leaderboard Bonus',
            coins: 175,
            date: '4 days ago',
            icon: Icons.trending_up,
            color: NeonTheme.neonPink,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value, Color color) {
    return Column(
      children: [
        ResponsiveCaption(label, color: Colors.white70),
        const SizedBox(height: 4),
        ResponsiveBody(value, color: color),
      ],
    );
  }

  Widget _buildRewardCard({
    required String title,
    required int coins,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
        color: color.withOpacity(0.08),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveBody(title, color: Colors.white),
                const SizedBox(height: 4),
                ResponsiveCaption(date, color: NeonTheme.textMuted),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color, width: 1),
            ),
            child: Text(
              '+$coins',
              style: TextStyle(color: color, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
