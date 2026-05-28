import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/providers/navigation_provider.dart';
import 'package:rrr_flutter_new/screens/games/games_screen.dart';
import 'package:rrr_flutter_new/screens/quizistan/quiz_play_screen.dart';
import 'package:rrr_flutter_new/screens/quizistan/quizistan_screen.dart';
import 'package:rrr_flutter_new/widgets/daily_bonus_dialog.dart';
import 'package:rrr_flutter_new/models/quiz_model.dart';

import '../../data/mock_quiz.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isQuizistanActive = true;

  final List<QuizistanQuiz> _fallbackQuizzes = [
    QuizistanQuiz(
      id: 'general_knowledge',
      title: 'General Knowledge',
      description: 'Test your broad knowledge.',
      genre: 'General',
      quizType: 'general',
      totalQuestions: 5,
      entryFee: 10,
      coinsPerCorrect: 20,
      isActive: true,
      timePerQuestion: 15,
      createdAt: DateTime.now(),
    ),
    QuizistanQuiz(
      id: 'sports_quiz',
      title: 'Sports Quiz',
      description: 'Test your sports knowledge.',
      genre: 'Sports',
      quizType: 'sports',
      totalQuestions: 5,
      entryFee: 15,
      coinsPerCorrect: 20,
      isActive: true,
      timePerQuestion: 15,
      createdAt: DateTime.now(),
    ),
    QuizistanQuiz(
      id: 'movies_quiz',
      title: 'Movies Quiz',
      description: 'Test your film knowledge.',
      genre: 'Movies',
      quizType: 'movies',
      totalQuestions: 5,
      entryFee: 10,
      coinsPerCorrect: 20,
      isActive: true,
      timePerQuestion: 15,
      createdAt: DateTime.now(),
    ),
    QuizistanQuiz(
      id: 'science_quiz',
      title: 'Science Quiz',
      description: 'Test your science knowledge.',
      genre: 'Sci',
      quizType: 'science',
      totalQuestions: 5,
      entryFee: 20,
      coinsPerCorrect: 24,
      isActive: true,
      timePerQuestion: 15,
      createdAt: DateTime.now(),
    ),
  ];

  void _showDailyBonus() async {
    final reward = await showDialog<int>(
      context: context,
      builder: (_) => const DailyBonusDialog(),
    );

    if (reward != null && reward > 0 && mounted) {
      context.read<WalletProvider>().addCoins(
        amount: reward,
        source: 'Daily Login Bonus',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Daily login bonus claimed! +$reward coins.'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _startQuiz(QuizModel quiz) {
    final wallet = context.read<WalletProvider>();
    if (wallet.coins < quiz.entryFee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins to join this quiz!')),
      );
      return;
    }

    wallet.spendCoins(amount: quiz.entryFee, source: 'Quiz Entry: ${quiz.title}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPlayScreen(
          quiz: quiz, questions: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coinBalance = context.watch<WalletProvider>().coins;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top custom row (Avatar, Switch, Coins, Notifications)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  // Profile Avatar
                  GestureDetector(
                    onTap: () => context.read<NavigationProvider>().setTab(3), // Navigate to Profile Tab
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryColor, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        backgroundColor: AppTheme.cardColor,
                        child: Text(
                          'RS',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  
                  // Top Tab switcher (Quizistan vs Gamistan)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => _isQuizistanActive = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isQuizistanActive ? AppTheme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Quizistan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _isQuizistanActive ? Colors.white : Colors.white60,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _isQuizistanActive = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: !_isQuizistanActive ? AppTheme.primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              'Gamistan',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: !_isQuizistanActive ? Colors.white : Colors.white60,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Coins indicator
                  GestureDetector(
                    onTap: () => context.read<NavigationProvider>().setTab(2), // Navigate to Wallet Tab
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.monetization_on, color: AppTheme.secondaryColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '$coinBalance',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            '+',
                            style: TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Notification bell
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.cardColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.notifications_none_rounded, color: Colors.white70, size: 18),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Tab Body
            Expanded(
              child: _isQuizistanActive ? _buildQuizistanView() : const GamesScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizistanView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        // Daily Login Bonus Banner Card
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.cardColor,
                AppTheme.primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DAILY LOGIN BONUS',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Come back tomorrow and\nwin more!',
                      style: TextStyle(fontSize: 12, color: Colors.white60, height: 1.3),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: AppTheme.secondaryColor, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          '50 Coins',
                          style: TextStyle(color: AppTheme.secondaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _showDailyBonus,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Claim Now',
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Golden Chest graphic simulation
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  size: 50,
                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),
        ),

        // Popular Quizzes section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Quizzes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to a dedicated quiz list page or show a Quizistan list
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuizistanScreen()),
                );
              },
              child: const Text(
                'View All',
                style: TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Quizzes list
        Column(
          children: _fallbackQuizzes.map((quiz) {
            return GestureDetector(
              onTap: () => _startQuiz(quiz as QuizModel),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    // Icon based on genre
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (quiz.genre == 'Sports' ? Colors.green : (quiz.genre == 'Sci' ? Colors.blue : Colors.purple)).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        quiz.genre == 'Sports' ? Icons.sports_soccer : (quiz.genre == 'Sci' ? Icons.science : Icons.public),
                        color: quiz.genre == 'Sports' ? Colors.green : (quiz.genre == 'Sci' ? Colors.blue : Colors.purpleAccent),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quiz.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'Win ${quiz.coinsPerCorrect * quiz.totalQuestions} Coins',
                                style: const TextStyle(color: AppTheme.secondaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•  Entry: ${quiz.entryFee} Coins',
                                style: const TextStyle(color: Colors.white54, fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 16),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Popular Games section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Games',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            GestureDetector(
              onTap: () => setState(() => _isQuizistanActive = false),
              child: const Text(
                'View All',
                style: TextStyle(color: Colors.blueAccent, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Single popular game item
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.directions_car_filled_rounded, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Car Racing Battle',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Win 200 Coins',
                          style: TextStyle(color: AppTheme.secondaryColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '•  Entry: 30 Coins',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('Play', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
