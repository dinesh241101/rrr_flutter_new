import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/providers/profile_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/services/wheel_rewards_repository.dart';
import 'package:rrr_flutter_new/widgets/responsive_button.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class ScratchCardScreen extends StatefulWidget {
  const ScratchCardScreen({super.key});

  @override
  State<ScratchCardScreen> createState() => _ScratchCardScreenState();
}

class _ScratchCardScreenState extends State<ScratchCardScreen> {
  WheelReward? selectedReward;
  bool isScratchCardRevealed = false;
  bool isLoadingNewCard = false;
  double scratchProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _prepareNewCard();
  }

  Future<void> _prepareNewCard() async {
    setState(() {
      isLoadingNewCard = true;
      isScratchCardRevealed = false;
      scratchProgress = 0.0;
    });

    try {
      final reward = await WheelRewardsRepository.selectRandomReward();
      setState(() {
        selectedReward = reward;
        isLoadingNewCard = false;
      });
    } catch (e) {
      setState(() {
        isLoadingNewCard = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error preparing card: $e')));
      }
    }
  }

  Future<void> _claimReward() async {
    if (selectedReward == null) return;

    // Show rewarded ad
    final adsService = AdsService.instance;
    final adReward = await adsService.showScratchCardRewarded(
      placement: 'scratch_card_bonus',
    );

    if (!mounted) return;

    // Record the reward claim
    final profileProvider = context.read<ProfileProvider>();
    if (profileProvider.isLoggedIn) {
      final totalReward = selectedReward!.coinReward + (adReward ?? 0);
      final success = await WheelRewardsRepository.submitRewardClaim(
        userId: profileProvider.profile!.id,
        rewardId: selectedReward!.id,
        coinsEarned: totalReward,
        source: 'scratch_card',
      );

      if (success) {
        // Update wallet
        context.read<WalletProvider>().addCoins(
          amount: totalReward,
          source: 'Scratch Card',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Congratulations! You earned $totalReward coins!'),
              backgroundColor: Colors.greenAccent,
            ),
          );
        }

        // Prepare next card after a delay
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          _prepareNewCard();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const ResponsiveHeading('Scratch Card'),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ResponsiveSubheading('Scratch & Win'),
            const SizedBox(height: 8),
            ResponsiveCaption(
              'Scratch the card to reveal your reward',
              textAlign: TextAlign.center,
              color: Colors.white70,
            ),
            const SizedBox(height: 32),
            // Scratch card
            if (selectedReward != null)
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    scratchProgress = (scratchProgress + 0.05).clamp(0.0, 1.0);
                    if (scratchProgress > 0.6) {
                      isScratchCardRevealed = true;
                    }
                  });
                },
                child: Container(
                  width: ResponsiveHelper.isMobile(context) ? 280 : 380,
                  height: ResponsiveHelper.isMobile(context) ? 280 : 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.orangeAccent.withOpacity(0.5),
                      width: 3,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.orangeAccent.withOpacity(0.2),
                        Colors.amber.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Revealed content
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: ResponsiveHelper.isMobile(context) ? 60 : 80,
                            color: Colors.orangeAccent.withOpacity(0.7),
                          ),
                          const SizedBox(height: 16),
                          ResponsiveHeading(
                            selectedReward!.name,
                            color: const Color(0xFF39FF14),
                          ),
                          const SizedBox(height: 8),
                          ResponsiveSubheading(
                            '+${selectedReward!.coinReward} Coins',
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(height: 8),
                          ResponsiveCaption(
                            selectedReward!.description,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      // Scratch overlay
                      if (!isScratchCardRevealed)
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey.shade700,
                                Colors.grey.shade600,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: ResponsiveHelper.isMobile(context)
                                      ? 48
                                      : 64,
                                  color: Colors.white70,
                                ),
                                const SizedBox(height: 16),
                                ResponsiveSubheading(
                                  'Scratch to Reveal',
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            if (isLoadingNewCard)
              Container(
                width: ResponsiveHelper.isMobile(context) ? 280 : 380,
                height: ResponsiveHelper.isMobile(context) ? 280 : 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orangeAccent.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
            const SizedBox(height: 32),
            // Progress indicator
            if (!isLoadingNewCard)
              Container(
                padding: EdgeInsets.all(
                  ResponsiveHelper.getResponsivePadding(
                    context,
                    mobilePadding: 12,
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white12, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveCaption(
                      'Scratch Progress: ${(scratchProgress * 100).toStringAsFixed(0)}%',
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: scratchProgress,
                        minHeight: 8,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(
                          scratchProgress > 0.6
                              ? Colors.greenAccent
                              : Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Action buttons
            if (!isLoadingNewCard)
              Column(
                children: [
                  if (isScratchCardRevealed)
                    SizedBox(
                      width: ResponsiveHelper.isMobile(context) ? 200 : 250,
                      child: ResponsiveButton(
                        label: 'Claim Reward',
                        onPressed: _claimReward,
                        backgroundColor: Colors.greenAccent,
                        textColor: Colors.black,
                      ),
                    )
                  else
                    ResponsiveCaption(
                      'Keep scratching to reveal your reward!',
                      textAlign: TextAlign.center,
                      color: Colors.white70,
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: ResponsiveHelper.isMobile(context) ? 200 : 250,
                    child: ResponsiveButton(
                      label: 'New Card',
                      onPressed: isScratchCardRevealed
                          ? () {
                              _prepareNewCard();
                            }
                          : () {},
                      backgroundColor: Colors.purpleAccent,
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            // Info box
            Container(
              padding: EdgeInsets.all(
                ResponsiveHelper.getResponsivePadding(
                  context,
                  mobilePadding: 16,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blueAccent.withOpacity(0.3),
                  width: 1,
                ),
                color: Colors.blueAccent.withOpacity(0.05),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveSubheading('How to Play'),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    '1',
                    'Scratch the card by dragging your finger',
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow('2', 'Reveal your hidden reward'),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    '3',
                    'Claim the reward and watch an ad for bonus',
                  ),
                  const SizedBox(height: 12),
                  ResponsiveCaption(
                    'Rewards vary based on luck. Play daily for more cards!',
                    textAlign: TextAlign.center,
                    color: Colors.white70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String number, String text) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent],
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: ResponsiveBody(text)),
      ],
    );
  }
}
