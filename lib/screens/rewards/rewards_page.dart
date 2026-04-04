import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/screens/rewards/spin_wheel_screen.dart';
import 'package:rrr_flutter_new/screens/rewards/scratch_card_screen.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveHeading('Rewards'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveSubheading('Available Rewards'),
            const SizedBox(height: 16),
            _buildRewardCard(
              context,
              title: 'Daily Bonus',
              description: 'Claim daily coins based on your streak',
              icon: Icons.calendar_today,
              color: Colors.blueAccent,
              onTap: () {
                // Navigate to daily bonus
              },
            ),
            const SizedBox(height: 16),
            _buildRewardCard(
              context,
              title: 'Spin the Wheel',
              description: 'Win bonus coins with our lucky wheel game',
              icon: Icons.sports_esports,
              color: Colors.purpleAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SpinWheelScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildRewardCard(
              context,
              title: 'Scratch Card',
              description: 'Scratch to reveal hidden rewards',
              icon: Icons.credit_card,
              color: Colors.orangeAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScratchCardScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildRewardCard(
              context,
              title: 'Achievements',
              description: 'Unlock badges and special rewards',
              icon: Icons.stars,
              color: Colors.greenAccent,
              onTap: () {
                // Navigate to achievements
              },
            ),
            const SizedBox(height: 24),
            _buildRewardInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          ResponsiveHelper.getResponsivePadding(context, mobilePadding: 16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveHelper.isMobile(context) ? 56 : 64,
              height: ResponsiveHelper.isMobile(context) ? 56 : 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                color: color,
                size: ResponsiveHelper.isMobile(context) ? 28 : 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSubheading(title),
                  const SizedBox(height: 4),
                  ResponsiveCaption(
                    description,
                    maxLines: 2,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(context, mobilePadding: 16),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.yellowAccent.withOpacity(0.3),
          width: 1,
        ),
        color: Colors.yellowAccent.withOpacity(0.05),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Colors.yellowAccent,
            size: ResponsiveHelper.isMobile(context) ? 24 : 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ResponsiveCaption(
              'View ads to earn bonus coins. Each game may offer rewarded ad bonuses.',
              maxLines: 3,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
