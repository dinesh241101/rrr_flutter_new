import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/models/profile_model.dart';
import 'package:rrr_flutter_new/providers/navigation_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/login/login_screen.dart';
import 'package:rrr_flutter_new/services/profile_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final profileService = ProfileService();

  ProfileModel? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await profileService.fetchProfile();

      if (mounted) {
        setState(() {
          profile = data;
          loading = false;
        });
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> _logout(BuildContext context) async {
    await profileService.logout();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    final coinBalance = context.watch<WalletProvider>().coins;

    if (loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final initials = (profile?.username ?? "RR")
        .substring(0, 2)
        .toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              /// AVATAR
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primaryColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.cardColor,
                  backgroundImage: profile?.avatarUrl != null
                      ? NetworkImage(profile!.avatarUrl!)
                      : null,
                  child: profile?.avatarUrl == null
                      ? Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 16),

              /// USERNAME + VERIFIED
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    profile?.username ?? "Guest User",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (profile?.isVerified == true)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(
                        Icons.verified,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 6),

              /// MOBILE
              Text(
                profile?.mobileNumber != null
                    ? "+91 ${profile!.mobileNumber}"
                    : "No mobile linked",
                style: const TextStyle(
                  color: Colors.white54,
                ),
              ),

              const SizedBox(height: 30),

              /// STATS
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(
                      "Coins",
                      "$coinBalance",
                      AppTheme.secondaryColor,
                    ),
                    _divider(),
                    _buildStat(
                      "Verified",
                      profile?.isVerified == true ? "YES" : "NO",
                      Colors.green,
                    ),
                    _divider(),
                    _buildStat(
                      "Games",
                      "12",
                      Colors.blueAccent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              _tile(
                icon: Icons.person_outline,
                title: "Edit Profile",
                onTap: () {},
              ),

              _tile(
                icon: Icons.history,
                title: "Coin History",
                onTap: () {
                  context.read<NavigationProvider>().setTab(2);
                },
              ),

              _tile(
                icon: Icons.security,
                title: "Security",
                onTap: () {},
              ),

              _tile(
                icon: Icons.logout,
                title: "Logout",
                color: AppTheme.errorColor,
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 35,
      color: Colors.white10,
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.white30,
        ),
      ),
    );
  }
}