import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
        child: Column(
          children: [
            // Custom Header
            _buildDrawerHeader(context, isDarkMode),
            const SizedBox(height: 20),

            // Navigation Items (Non-scrolling, wrapped in Expanded to prevent overflow)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDrawerItem(
                      context,
                      icon: Icons.account_circle_outlined,
                      title: 'Profile',
                      route: '/profile_screen',
                      isDarkMode: isDarkMode,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.history,
                      title: 'Reward History',
                      route: '/reward_history_screen',
                      isDarkMode: isDarkMode,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.notifications_active_outlined,
                      title: 'Notifications',
                      route: '/notifications_screen',
                      isDarkMode: isDarkMode,
                    ),
                    _buildDrawerItem(
                      context,
                      icon: Icons.info_outline,
                      title: 'About',
                      route: '/about_screen',
                      isDarkMode: isDarkMode,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Container(
                        color: isDarkMode
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey[300],
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // // Additional Options
            // _buildDrawerItem(
            //   context,
            //   icon: Icons.settings_outlined,
            //   title: 'Settings',
            //   route: '/settings_screen',
            //   isDarkMode: isDarkMode,
            // ),
            // _buildDrawerItem(
            //   context,
            //   icon: Icons.help_outline,
            //   title: 'Help & Support',
            //   route: '/help_screen',
            //   isDarkMode: isDarkMode,
            // ),

            const Spacer(),

            // Logout Button at Bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F4C81),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Custom Header Widget with Dark Theme Support
  Widget _buildDrawerHeader(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F4C81), Color(0xFF1B5BAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_circle,
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Run Reward Rift',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Your gaming rewards hub',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget with Dark Theme Support
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
    required bool isDarkMode,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0F4C81), size: 24),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isDarkMode ? Colors.white : const Color(0xFF333333),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDarkMode
              ? Colors.white.withOpacity(0.3)
              : const Color(0xFFCCCCCC),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        hoverColor: const Color(0xFF0F4C81).withOpacity(0.1),
        onTap: () => _navigateTo(context, route),
      ),
    );
  }

  // Navigation Handler
  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushNamed(context, route);
  }

  // Logout Handler
  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Sign out from Supabase
                await Supabase.instance.client.auth.signOut();

                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close drawer
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (Route<dynamic> route) => false,
                  );
                }
              } catch (e) {
                print('Logout error: $e');
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
