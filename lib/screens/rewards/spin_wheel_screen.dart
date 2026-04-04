import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/providers/profile_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/services/wheel_rewards_repository.dart';
import 'package:rrr_flutter_new/widgets/responsive_button.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';
import 'dart:math' as math;

class SpinWheelScreen extends StatefulWidget {
  const SpinWheelScreen({super.key});

  @override
  State<SpinWheelScreen> createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  List<WheelReward> rewards = [];
  WheelReward? selectedReward;
  bool isSpinning = false;
  bool isLoadingRewards = true;
  bool showRewardResult = false;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _loadRewards();
  }

  Future<void> _loadRewards() async {
    try {
      final loadedRewards = await WheelRewardsRepository.getActiveRewards();
      setState(() {
        rewards = loadedRewards;
        isLoadingRewards = false;
      });
    } catch (e) {
      setState(() {
        isLoadingRewards = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading rewards: $e')));
      }
    }
  }

  Future<void> _spinWheel() async {
    if (isSpinning || rewards.isEmpty) return;

    // Show ad request first
    final adsService = AdsService.instance;
    final adReward = await adsService.showSpinWheelRewarded(
      placement: 'spin_wheel_bonus',
    );

    if (!mounted) return;

    setState(() {
      isSpinning = true;
      showRewardResult = false;
    });

    // Select a random reward
    final reward = await WheelRewardsRepository.selectRandomReward();

    if (reward == null) {
      setState(() {
        isSpinning = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Error selecting reward')));
      }
      return;
    }

    // Animate the spin
    final randomSpins = math.Random().nextInt(5) + 3;
    final spinAngle =
        (randomSpins * 2 * math.pi) +
        ((rewards.indexOf(reward) / rewards.length) * 2 * math.pi);

    await _spinController.animateTo(
      spinAngle,
      duration: const Duration(seconds: 5),
      curve: Curves.decelerate,
    );

    setState(() {
      selectedReward = reward;
      isSpinning = false;
      showRewardResult = true;
    });

    // Record the reward claim
    final profileProvider = context.read<ProfileProvider>();
    if (profileProvider.isLoggedIn) {
      final success = await WheelRewardsRepository.submitRewardClaim(
        userId: profileProvider.profile!.id,
        rewardId: reward.id,
        coinsEarned:
            reward.coinReward +
            (adReward ?? 0), // Add ad reward bonus if available
        source: 'spin_wheel',
      );

      if (success) {
        // Update wallet
        context.read<WalletProvider>().addCoins(
          amount: reward.coinReward + (adReward ?? 0),
          source: 'Spin Wheel',
        );
      }
    }
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveHeading('Spin the Wheel'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoadingRewards
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(context),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ResponsiveSubheading('Try Your Luck!'),
                  const SizedBox(height: 8),
                  ResponsiveCaption(
                    'Watch an ad to spin and win coins',
                    textAlign: TextAlign.center,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 32),
                  // Wheel visualization
                  Container(
                    width: ResponsiveHelper.isMobile(context) ? 300 : 400,
                    height: ResponsiveHelper.isMobile(context) ? 300 : 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.blueAccent.withOpacity(0.2),
                          Colors.purpleAccent.withOpacity(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: Colors.white12, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: RotationTransition(
                      turns: Tween(begin: 0.0, end: 1.0)
                          .chain(CurveTween(curve: Curves.decelerate))
                          .animate(_spinController),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Wheel segments
                          ..._buildWheelSegments(),
                          // Center circle
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueAccent,
                                  Colors.purpleAccent,
                                ],
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Pointer
                  const SizedBox(height: 16),
                  CustomPaint(
                    painter: TrianglePointer(),
                    size: const Size(30, 20),
                  ),
                  const SizedBox(height: 32),
                  // Reward result display
                  if (showRewardResult && selectedReward != null)
                    Container(
                      padding: EdgeInsets.all(
                        ResponsiveHelper.getResponsivePadding(
                          context,
                          mobilePadding: 16,
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.greenAccent.withOpacity(0.3),
                            Colors.lightGreen.withOpacity(0.2),
                          ],
                        ),
                        border: Border.all(color: Colors.greenAccent, width: 2),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.celebration,
                            size: 40,
                            color: Colors.greenAccent,
                          ),
                          const SizedBox(height: 12),
                          ResponsiveHeading(
                            selectedReward!.name,
                            color: Colors.greenAccent,
                          ),
                          const SizedBox(height: 8),
                          ResponsiveSubheading(
                            '+${selectedReward!.coinReward} Coins',
                            color: const Color(0xFF39FF14),
                          ),
                          const SizedBox(height: 8),
                          ResponsiveBody(
                            selectedReward!.description,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 32),
                  // Spin button
                  SizedBox(
                    width: ResponsiveHelper.isMobile(context) ? 200 : 250,
                    child: ResponsiveButton(
                      label: isSpinning ? 'Spinning...' : 'SPIN WHEEL',
                      onPressed: isSpinning
                          ? () {}
                          : () {
                              _spinWheel();
                            },
                      backgroundColor: Colors.orangeAccent,
                      textColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Reward list
                  if (rewards.isNotEmpty)
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
                          ResponsiveSubheading('Prize Tiers'),
                          const SizedBox(height: 12),
                          ...rewards
                              .map(
                                (reward) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ResponsiveBody(reward.name),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent.withOpacity(
                                            0.3,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: ResponsiveCaption(
                                          '${reward.coinReward} coins',
                                          color: const Color(0xFF39FF14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  List<Widget> _buildWheelSegments() {
    if (rewards.isEmpty) return [];

    final angle = 360 / rewards.length;
    final colors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];

    return List.generate(rewards.length, (index) {
      return Transform.rotate(
        angle: (index * angle * math.pi / 180),
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: 80,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors[index % colors.length].withOpacity(0.6),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Text(
                  rewards[index].coinReward.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

/// Custom painter for pointer triangle
class TrianglePointer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellowAccent
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TrianglePointer oldDelegate) => false;
}
