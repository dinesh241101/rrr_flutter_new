import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';
import 'package:rrr_flutter_new/data/mock_quiz.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/quizistan/quiz_play_screen.dart';

class QuizistanScreen extends StatefulWidget {
  const QuizistanScreen({super.key});

  @override
  State<QuizistanScreen> createState() => _QuizistanScreenState();
}

class _QuizistanScreenState extends State<QuizistanScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'General', 'Sports', 'Movies', 'Sci'];

  final List<QuizistanQuiz> _quizzes = [
    QuizistanQuiz(
      id: 'gk',
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
      id: 'sports',
      title: 'Sports Quiz',
      description: 'Football, Cricket, Tennis and more.',
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
      id: 'movies',
      title: 'Movies Quiz',
      description: 'Cinema, trivia, actors, and directors.',
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
      id: 'science',
      title: 'Science Quiz',
      description: 'Physics, chemistry, biology, space.',
      genre: 'Sci',
      quizType: 'science',
      totalQuestions: 5,
      entryFee: 20,
      coinsPerCorrect: 24,
      isActive: true,
      timePerQuestion: 15,
      createdAt: DateTime.now(),
    ),
    QuizistanQuiz(
      id: 'current_affairs',
      title: 'Current Affairs',
      description: 'Global news and events.',
      genre: 'General',
      quizType: 'general',
      totalQuestions: 5,
      entryFee: 25,
      coinsPerCorrect: 30,
      isActive: true,
      timePerQuestion: 15,
      createdAt: DateTime.now(),
    ),
  ];

  void _startQuiz(QuizistanQuiz quiz) {
    final wallet = context.read<WalletProvider>();
    if (wallet.coins < quiz.entryFee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough coins!')),
      );
      return;
    }

    wallet.spendCoins(amount: quiz.entryFee, source: 'Quiz Entry: ${quiz.title}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPlayScreen(
          quiz: quiz,
          questions: MockQuizData.questions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coinBalance = context.watch<WalletProvider>().coins;

    final filteredQuizzes = _selectedCategory == 'All'
        ? _quizzes
        : _quizzes.where((q) => q.genre == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('All Quizzes'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: AppTheme.secondaryColor, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$coinBalance',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            // Categories Horizontal Scroll Bar
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? Colors.transparent : Colors.white10),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Quiz list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredQuizzes.length,
                itemBuilder: (context, index) {
                  final quiz = filteredQuizzes[index];
                  IconData icon = Icons.public_rounded;
                  Color iconColor = Colors.purpleAccent;
                  String activeCount = '1.2K+ Playing';

                  if (quiz.genre == 'Sports') {
                    icon = Icons.sports_soccer_rounded;
                    iconColor = Colors.green;
                    activeCount = '1.5K+ Playing';
                  } else if (quiz.genre == 'Movies') {
                    icon = Icons.movie_creation_rounded;
                    iconColor = Colors.amber;
                    activeCount = '900+ Playing';
                  } else if (quiz.genre == 'Sci') {
                    icon = Icons.science_rounded;
                    iconColor = Colors.blue;
                    activeCount = '350+ Playing';
                  }

                  return GestureDetector(
                    onTap: () => _startQuiz(quiz),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(icon, color: iconColor, size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quiz.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.monetization_on, color: AppTheme.secondaryColor, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Win ${quiz.coinsPerCorrect * quiz.totalQuestions}',
                                      style: const TextStyle(
                                        color: AppTheme.secondaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Entry: ${quiz.entryFee} Coins',
                                      style: const TextStyle(
                                        color: Colors.white54,
                                        fontSize: 11,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      activeCount,
                                      style: const TextStyle(
                                        color: Colors.white30,
                                        fontSize: 10,
                                      ),
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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
