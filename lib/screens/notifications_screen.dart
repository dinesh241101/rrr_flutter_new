import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('Notifications', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            title: 'Daily Bonus Claimed',
            message: 'You claimed your daily bonus of 100 coins!',
            time: '2 hours ago',
            icon: Icons.card_giftcard,
            color: NeonTheme.neonLime,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Quiz Completed',
            message:
                'Great! You completed "General Knowledge" quiz with 85% accuracy.',
            time: '5 hours ago',
            icon: Icons.quiz,
            color: NeonTheme.neonCyan,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Ad Reward',
            message: 'You earned 50 coins from watching an ad!',
            time: '1 day ago',
            icon: Icons.play_circle_outline,
            color: NeonTheme.neonPink,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Tournament Started',
            message: 'Weekly Tournament "Speed Games" has started. Join now!',
            time: '2 days ago',
            icon: Icons.emoji_events,
            color: NeonTheme.neonPurple,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: 'Leaderboard Update',
            message: 'You climbed to rank #5 in this week\'s leaderboard!',
            time: '3 days ago',
            icon: Icons.trending_up,
            color: NeonTheme.neonOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String message,
    required String time,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveSubheading(title, color: color),
                const SizedBox(height: 6),
                ResponsiveCaption(
                  message,
                  color: NeonTheme.textMuted,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                ResponsiveCaption(time, color: NeonTheme.textMuted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
