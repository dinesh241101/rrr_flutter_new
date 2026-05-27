import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';

class DailyBonusDialog extends StatefulWidget {
  const DailyBonusDialog({super.key});

  @override
  State<DailyBonusDialog> createState() => _DailyBonusDialogState();
}

class _DailyBonusDialogState extends State<DailyBonusDialog> {
  final int _currentDayIndex = 2; // Day 3 is active in the mockup
  final List<int> _rewards = [20, 30, 50, 60, 70, 100, 150];

  void _claimBonus() {
    final reward = _rewards[_currentDayIndex];
    Navigator.pop(context, reward);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white12),
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                const Text(
                  'DAILY LOGIN BONUS',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.1,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white70, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Subtitle
            const Text(
              'Day 3 of your streak',
              style: TextStyle(color: AppTheme.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Grid for Days 1 to 7
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.85,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                final dayNum = index + 1;
                final reward = _rewards[index];
                final isClaimed = index < _currentDayIndex;
                final isActive = index == _currentDayIndex;

                Color cardBorderColor = Colors.white10;
                Color cardBgColor = AppTheme.cardColor;
                if (isActive) {
                  cardBorderColor = AppTheme.primaryColor;
                }

                return Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorderColor, width: isActive ? 2 : 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Day $dayNum',
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive ? Colors.white : Colors.white60,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Circle icon/number
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: isClaimed
                              ? AppTheme.primaryColor
                              : (isActive ? AppTheme.primaryColor.withOpacity(0.1) : Colors.white.withOpacity(0.05)),
                          shape: BoxShape.circle,
                        ),
                        child: isClaimed
                            ? const Icon(Icons.check, color: Colors.white, size: 16)
                            : Center(
                                child: Text(
                                  '$reward',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isActive ? AppTheme.primaryColor : Colors.white70,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Coins',
                        style: TextStyle(
                          fontSize: 9,
                          color: isActive ? AppTheme.secondaryColor : Colors.white30,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Big Yellow Claim Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _claimBonus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Claim ${_rewards[_currentDayIndex]} Coins',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}