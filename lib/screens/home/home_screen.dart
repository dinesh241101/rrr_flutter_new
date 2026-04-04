import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/core/neon_theme.dart';
import 'package:rrr_flutter_new/data/mock_games.dart';
import 'package:rrr_flutter_new/providers/navigation_provider.dart';
import 'package:rrr_flutter_new/providers/profile_provider.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/games/game_play_screen.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/widgets/featured_game_card.dart';
import 'package:rrr_flutter_new/widgets/responsive_button.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  void _loadBannerAd() {
    _bannerAd = AdsService.instance.createHomeBannerAd(
      onLoaded: () {
        if (!mounted) {
          return;
        }
        setState(() {
          _isBannerLoaded = true;
        });
      },
      onFailedToLoad: (LoadAdError error) {
        debugPrint('Home banner ad failed to load: $error');
        if (!mounted) {
          return;
        }
        setState(() {
          _isBannerLoaded = false;
        });
      },
    );
  }

  Future<void> _showRewardedAd(BuildContext context) async {
    final int? reward = await AdsService.instance.showRewarded(
      placement: 'home_bonus',
      rewardCoins: AppValues.rewardedAdBonusCoins,
    );
    if (!context.mounted || reward == null) {
      return;
    }
    context.read<WalletProvider>().addCoins(
      amount: reward,
      source: 'Rewarded Ad',
    );
    context.read<SessionProvider>().trackAdSeen();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rewarded ad complete. +$reward coins added.'),
          backgroundColor: NeonTheme.neonLime,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileProvider, WalletProvider, SessionProvider>(
      builder:
          (
            BuildContext context,
            ProfileProvider profile,
            WalletProvider wallet,
            SessionProvider session,
            _,
          ) {
            final int sessionMinutes = session.sessionDuration.inMinutes;
            final String userName = profile.profile?.username ?? 'User';
            return Container(
              color: NeonTheme.darkBg,
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        /// WELCOME SECTION WITH NEON GLOW
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: NeonTheme.rainbowNeonGradient,
                            boxShadow: [
                              BoxShadow(
                                color: NeonTheme.neonCyan.withOpacity(0.4),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: NeonTheme.neonPurple.withOpacity(0.2),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ResponsiveHeading(
                                'Welcome back, $userName!',
                                color: Colors.white,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildStatItem(
                                    'Coins',
                                    wallet.coins.toString(),
                                    NeonTheme.neonLime,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildStatItem(
                                    'Session',
                                    '${sessionMinutes}m',
                                    NeonTheme.neonCyan,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildStatItem(
                                    'Ads',
                                    session.adsSeenThisSession.toString(),
                                    NeonTheme.neonPink,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// AD BONUS SECTION
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: NeonTheme.neonPink,
                              width: 2,
                            ),
                            color: NeonTheme.neonPink.withOpacity(0.08),
                            boxShadow: NeonTheme.neonPinkShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: NeonTheme.neonPink,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ResponsiveSubheading(
                                          'Earn Bonus Coins',
                                          color: NeonTheme.neonPink,
                                        ),
                                        ResponsiveCaption(
                                          'Watch an ad for instant rewards',
                                          color: NeonTheme.textMuted,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ResponsiveButton(
                                  label: 'Watch Now',
                                  onPressed: () => _showRewardedAd(context),
                                  backgroundColor: NeonTheme.neonPink,
                                  textColor: NeonTheme.darkBg,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// FEATURED GAMES HEADER
                        ResponsiveSubheading(
                          'Featured Games',
                          color: NeonTheme.neonCyan,
                        ),
                        const SizedBox(height: 12),

                        /// FEATURED GAMES
                        FeaturedGameCard(
                          game: MockGames.all.first,
                          onPlay: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    GamePlayScreen(game: MockGames.all.first),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        FeaturedGameCard(
                          game: MockGames.all[1],
                          onPlay: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    GamePlayScreen(game: MockGames.all[1]),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        /// QUICK NAVIGATE
                        ResponsiveSubheading(
                          'Quick Navigate',
                          color: NeonTheme.neonPurple,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildQuickNavButton(
                              context,
                              'Games',
                              Icons.sports_esports,
                              NeonTheme.neonCyan,
                              1,
                            ),
                            _buildQuickNavButton(
                              context,
                              'Tournament',
                              Icons.emoji_events,
                              NeonTheme.neonPurple,
                              2,
                            ),
                            _buildQuickNavButton(
                              context,
                              'Quizistan',
                              Icons.quiz,
                              NeonTheme.neonPink,
                              3,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_isBannerLoaded && _bannerAd != null)
                    SafeArea(
                      top: false,
                      child: Container(
                        color: NeonTheme.darkBg2,
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: _bannerAd!.size.width.toDouble(),
                          height: _bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd!),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.1),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Column(
          children: [
            ResponsiveCaption(label, color: Colors.white70),
            const SizedBox(height: 6),
            ResponsiveBody(value, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickNavButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    int tabIndex,
  ) {
    return GestureDetector(
      onTap: () => context.read<NavigationProvider>().setTab(tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
          color: color.withOpacity(0.1),
          boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            ResponsiveBody(label, color: color),
          ],
        ),
      ),
    );
  }
}
