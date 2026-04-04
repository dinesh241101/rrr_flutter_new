import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeonTheme.darkBg,
      appBar: AppBar(
        title: const ResponsiveSubheading('About', color: Colors.white),
        backgroundColor: NeonTheme.darkBg2,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Title Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: NeonTheme.rainbowNeonGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: NeonTheme.neonCyan.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.videogame_asset,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ResponsiveHeading(
                    'Run Reward Rift',
                    color: NeonTheme.neonCyan,
                  ),
                  const SizedBox(height: 8),
                  ResponsiveCaption(
                    'Version 1.0.0',
                    color: NeonTheme.textMuted,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // About Section
            ResponsiveSubheading('About the App', color: NeonTheme.neonLime),
            const SizedBox(height: 12),
            Text(
              'Run Reward Rift is your ultimate gaming rewards hub! Play exciting games, take quizzes, participate in tournaments, and spin the wheel to earn coins. Enjoy an immersive experience with smooth gameplay and rewarding challenges.',
              style: TextStyle(
                color: NeonTheme.textMuted,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Features Section
            ResponsiveSubheading('Features', color: NeonTheme.neonPink),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.sports_esports,
              title: 'Play Games',
              description: 'Enjoy a variety of fun games and win coins',
              color: NeonTheme.neonCyan,
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.quiz,
              title: 'Quiz Challenges',
              description: 'Test your knowledge and earn rewards',
              color: NeonTheme.neonPurple,
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.emoji_events,
              title: 'Tournaments',
              description: 'Compete with others and climb the leaderboard',
              color: NeonTheme.neonOrange,
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              icon: Icons.catching_pokemon,
              title: 'Spin Wheel',
              description: 'Try your luck and win exciting rewards',
              color: NeonTheme.neonLime,
            ),
            const SizedBox(height: 24),

            // Contact Section
            ResponsiveSubheading(
              'Support & Contact',
              color: NeonTheme.neonCyan,
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.email,
              title: 'Email',
              value: 'support@runrewardrift.com',
            ),
            const SizedBox(height: 12),
            _buildContactItem(
              icon: Icons.language,
              title: 'Website',
              value: 'www.runrewardrift.com',
            ),
            const SizedBox(height: 24),

            // Terms & Legal
            ResponsiveSubheading('Legal', color: NeonTheme.neonPink),
            const SizedBox(height: 12),
            _buildLegalLink('Terms of Service'),
            const SizedBox(height: 8),
            _buildLegalLink('Privacy Policy'),
            const SizedBox(height: 8),
            _buildLegalLink('Community Guidelines'),
            const SizedBox(height: 32),

            // Footer
            Center(
              child: Column(
                children: [
                  ResponsiveCaption(
                    '© 2024 Run Reward Rift. All rights reserved.',
                    color: NeonTheme.textMuted,
                  ),
                  const SizedBox(height: 8),
                  ResponsiveCaption(
                    'Made with ❤️ for gamers',
                    color: NeonTheme.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveBody(title, color: color),
              const SizedBox(height: 4),
              ResponsiveCaption(description, color: NeonTheme.textMuted),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: NeonTheme.neonCyan, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveCaption(title, color: NeonTheme.textMuted),
              ResponsiveBody(value, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegalLink(String title) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          Icon(Icons.arrow_forward_ios, size: 14, color: NeonTheme.neonPink),
          const SizedBox(width: 8),
          ResponsiveBody(title, color: NeonTheme.neonPink),
        ],
      ),
    );
  }
}
