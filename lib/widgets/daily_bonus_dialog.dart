import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyBonusDialog extends StatefulWidget {
  const DailyBonusDialog({super.key});

  static const String _lastClaimKey = "daily_bonus_last_claim";
  static const String _streakKey = "daily_bonus_streak";

  /// 🔥 STREAK REWARD SYSTEM
  static const List<int> rewards = [20, 30, 50, 80, 120, 200, 500];

  /// CHECK IF SHOULD SHOW
  static Future<bool> shouldShow() async  {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt(_lastClaimKey);

    if (last == null) return true;

    final lastDate = DateTime.fromMillisecondsSinceEpoch(last);
    final now = DateTime.now();

    return now.difference(lastDate).inHours >= 24;
  }

  /// GET CURRENT STREAK
  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }

  /// UPDATE STREAK
  static Future<int> updateStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt(_lastClaimKey);

    int streak = prefs.getInt(_streakKey) ?? 0;

    final now = DateTime.now();

    if (last != null) {
      final lastDate = DateTime.fromMillisecondsSinceEpoch(last);
      final diff = now.difference(lastDate).inHours;

      if (diff > 48) {
        streak = 0; // reset
      }
    }

    streak = (streak + 1) % rewards.length;

    await prefs.setInt(_streakKey, streak);
    await prefs.setInt(_lastClaimKey, now.millisecondsSinceEpoch);

    return streak;
  }

  @override
  State<DailyBonusDialog> createState() => _DailyBonusDialogState();
}

class _DailyBonusDialogState extends State<DailyBonusDialog> {
  late ConfettiController _confettiController;
  late ConfettiController _coinRainController;

  int streak = 0;
  int reward = 0;

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));

    _coinRainController =
        ConfettiController(duration: const Duration(seconds: 3));

    _init();
  }

  Future<void> _init() async {
    final s = await DailyBonusDialog.getStreak();
    setState(() {
      streak = s;
      reward = DailyBonusDialog.rewards[s];
    });
  }

  Future<void> _claim() async {
    final newStreak = await DailyBonusDialog.updateStreak();

    _confettiController.play();
    _coinRainController.play();

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.pop(context, reward);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _coinRainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// 🎮 MAIN CARD
          Container(
            width: width < 400 ? width * 0.9 : 360,
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF0B1F3A), Color(0xFF050816)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  blurRadius: 25,
                ),
              ],
              border: Border.all(color: Colors.blueAccent.withOpacity(0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// TITLE
                const Text(
                  "🔥 Daily Streak Bonus",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// STREAK INFO
                Text(
                  "Day ${streak + 1}",
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 10),

                /// REWARD
                Text(
                  "+$reward Coins",
                  style: const TextStyle(
                    color: Colors.amber,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 20),

                /// STREAK BAR
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    DailyBonusDialog.rewards.length,
                        (i) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i <= streak
                            ? Colors.blueAccent
                            : Colors.white24,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// CLAIM BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _claim,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "CLAIM",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// ❌ CLOSE BUTTON
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),

          /// 🎉 CONFETTI BURST
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 25,
              ),
            ),
          ),

          /// 🪙 COIN RAIN (FALLING)
          Positioned.fill(
            child: ConfettiWidget(
              confettiController: _coinRainController,
              blastDirection: pi / 2,
              emissionFrequency: 0.02,
              numberOfParticles: 10,
              gravity: 0.4,
              colors: const [
                Colors.amber,
                Colors.yellow,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
    );
  }
}