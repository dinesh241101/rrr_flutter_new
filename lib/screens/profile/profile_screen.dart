import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/providers/profile_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/login/login_screen.dart';
import 'package:rrr_flutter_new/screens/rewards/rewards_page.dart';
import 'package:rrr_flutter_new/widgets/responsive_button.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, _) {
        // If user is not logged in, show login page
        if (!profileProvider.isLoggedIn) {
          return _buildLoginPrompt(context);
        }

        // User is logged in, show profile information
        return _buildProfilePage(context, profileProvider);
      },
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle,
              size: 80,
              color: Colors.blueAccent.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            ResponsiveHeading('Welcome to RRR'),
            const SizedBox(height: 12),
            ResponsiveBody(
              'Please log in to view your profile and unlock all features',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ResponsiveButton(
              label: 'Login',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              backgroundColor: Colors.blueAccent,
            ),
            const SizedBox(height: 12),
            ResponsiveButton(
              label: 'Continue as Guest',
              onPressed: () {
                // Continue as guest - can be implemented later
              },
              backgroundColor: Colors.white12,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage(
    BuildContext context,
    ProfileProvider profileProvider,
  ) {
    final profile = profileProvider.profile!;
    final wallet = context.read<WalletProvider>();

    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveHelper.getResponsivePadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(context, mobilePadding: 16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.purpleAccent.withOpacity(0.3),
                ],
              ),
              border: Border.all(color: Colors.white12, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (profile.username?.isNotEmpty ?? false)
                          ? profile.username!.substring(0, 1).toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveSubheading(
                        profile.username ?? 'Player',
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      ResponsiveCaption(
                        profile.email ?? 'Not verified',
                        maxLines: 1,
                      ),
                      const SizedBox(height: 8),
                      if (profile.isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green, width: 1),
                          ),
                          child: ResponsiveCaption(
                            '✓ Verified',
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Wallet & Stats
          Container(
            padding: EdgeInsets.all(
              ResponsiveHelper.getResponsivePadding(context, mobilePadding: 16),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12, width: 1),
              color: Colors.white.withOpacity(0.02),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveSubheading('Wallet & Stats'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      context,
                      'Coins',
                      wallet.coins.toString(),
                      const Color(0xFF39FF14),
                    ),
                    _buildStatCard(
                      context,
                      'Member Since',
                      '${profile.createdAt.month}/${profile.createdAt.day}/${profile.createdAt.year}',
                      Colors.blueAccent,
                    ),
                    _buildStatCard(
                      context,
                      'Mobile',
                      profile.mobileNumber ?? 'Not set',
                      const Color(0xFF00F0FF),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Bio Section
          if (profile.bio != null && profile.bio!.isNotEmpty)
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobilePadding: 16,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12, width: 1),
                color: Colors.white.withOpacity(0.02),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSubheading('Bio'),
                  const SizedBox(height: 8),
                  ResponsiveBody(profile.bio!),
                ],
              ),
            ),
          const SizedBox(height: 24),

          // Quick Actions
          ResponsiveSubheading('Quick Actions'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ResponsiveButton(
              label: 'Explore Rewards',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RewardsPage()),
                );
              },
              backgroundColor: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ResponsiveButton(
              label: 'Edit Profile',
              onPressed: () {
                // Later: show profile edit dialog
              },
              backgroundColor: Colors.purpleAccent,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ResponsiveOutlineButton(
              label: 'Logout',
              onPressed: () {
                context.read<ProfileProvider>().clearProfile();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              borderColor: Colors.red,
              textColor: Colors.red,
            ),
          ),
        ],
      ),
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
        const SizedBox(height: 8),
        ResponsiveSubheading(value, color: color, maxLines: 1),
      ],
    );
  }
}

// Placeholder OutlineButton for responsive design
class ResponsiveOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color borderColor;
  final Color textColor;

  const ResponsiveOutlineButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.borderColor = Colors.blueAccent,
    this.textColor = Colors.blueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = ResponsiveHelper.getResponsiveFontSize(
      context,
      mobileSize: 14,
      tabletSize: 16,
      desktopSize: 18,
    );

    return Container(
      height: ResponsiveHelper.isMobile(context) ? 48 : 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
