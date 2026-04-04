import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/core/responsive_helper.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';
import 'package:rrr_flutter_new/providers/quiz_provider.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';
import 'package:rrr_flutter_new/services/quizistan_repository.dart';
import 'package:rrr_flutter_new/widgets/responsive_text.dart';

class QuizistanScreen extends StatefulWidget {
  const QuizistanScreen({super.key});

  @override
  State<QuizistanScreen> createState() => _QuizistanScreenState();
}

class _QuizistanScreenState extends State<QuizistanScreen> {
  bool _isListView = false;
  late Future<List<QuizistanQuiz>> _quizzesFuture;

  @override
  void initState() {
    super.initState();
    _quizzesFuture = QuizistanRepository.getActiveQuizzes();
  }

  Future<void> _handleAnswer(BuildContext context, int optionIndex) async {
    final QuizProvider quiz = context.read<QuizProvider>();
    final bool correct = quiz.answerCurrent(optionIndex);
    if (correct) {
      context.read<WalletProvider>().addCoins(
        amount: AppValues.quizCorrectAnswerReward,
        source: 'Quiz correct answer',
      );
    }

    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          correct
              ? 'Correct! +${AppValues.quizCorrectAnswerReward} coins'
              : 'Wrong answer. Try the next one.',
        ),
      ),
    );

    if (!quiz.completed) {
      return;
    }

    final bool shown = await AdsService.instance.showInterstitial(
      placement: 'quiz_completed',
    );
    if (!context.mounted || !shown) {
      return;
    }
    context.read<SessionProvider>().trackAdSeen();
  }

  void _startQuiz(BuildContext context, QuizistanQuiz quiz) {
    final userCoins = context.read<WalletProvider>().coins;
    if (userCoins < quiz.entryFee) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not enough coins. Need ${quiz.entryFee}')),
      );
      return;
    }

    // Deduct entry fee
    context.read<WalletProvider>().spendCoins(
      amount: quiz.entryFee,
      source: 'Quizistan entry fee',
    );

    // Navigate to quiz play screen or show quiz interface
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Starting quiz: ${quiz.title}')));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // View Toggle
        Container(
          padding: EdgeInsets.all(
            ResponsiveHelper.getResponsivePadding(context, mobilePadding: 12),
          ),
          color: const Color(0xFF1A1F3A),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ResponsiveSubheading('Available Quizzes'),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _isListView = false),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: !_isListView
                              ? Colors.blueAccent
                              : Colors.white12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.dashboard,
                        color: !_isListView
                            ? Colors.blueAccent
                            : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _isListView = true),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isListView
                              ? Colors.blueAccent
                              : Colors.white12,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        Icons.list,
                        color: _isListView ? Colors.blueAccent : Colors.white70,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<QuizistanQuiz>>(
            future: _quizzesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF00F0FF),
                    ),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(child: ResponsiveBody('Error loading quizzes'));
              }

              final quizzes = snapshot.data ?? [];

              if (quizzes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.quiz, size: 64, color: Colors.white30),
                      const SizedBox(height: 16),
                      const ResponsiveBody(
                        'No quizzes available',
                        color: Colors.white70,
                      ),
                    ],
                  ),
                );
              }

              if (!_isListView) {
                return GridView.builder(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(context),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: ResponsiveHelper.isMobile(context) ? 2 : 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return _buildQuizTile(context, quiz);
                  },
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(
                    ResponsiveHelper.getResponsivePadding(context),
                  ),
                  itemCount: quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = quizzes[index];
                    return _buildQuizListItem(context, quiz);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuizTile(BuildContext context, QuizistanQuiz quiz) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12, width: 1),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.08),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(11),
                ),
                gradient: LinearGradient(
                  colors: [
                    Colors.blueAccent.withOpacity(0.3),
                    Colors.purpleAccent.withOpacity(0.3),
                  ],
                ),
              ),
              child: Center(
                child: Icon(Icons.quiz, color: Colors.blueAccent, size: 40),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveSubheading(quiz.title, maxLines: 2),
                const SizedBox(height: 4),
                ResponsiveCaption(
                  '${quiz.totalQuestions} questions',
                  color: Colors.white70,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                ResponsiveCaption(
                  '${quiz.entryFee} coins entry',
                  color: const Color(0xFF39FF14),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _startQuiz(context, quiz),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const ResponsiveCaption('Play', color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizListItem(BuildContext context, QuizistanQuiz quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(
        ResponsiveHelper.getResponsivePadding(context, mobilePadding: 12),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12, width: 1),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Colors.blueAccent.withOpacity(0.3),
                  Colors.purpleAccent.withOpacity(0.3),
                ],
              ),
            ),
            child: Icon(Icons.quiz, color: Colors.blueAccent, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveSubheading(quiz.title, maxLines: 1),
                const SizedBox(height: 4),
                ResponsiveCaption(
                  '${quiz.totalQuestions} questions • ${quiz.entryFee} coins',
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _startQuiz(context, quiz),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Play', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
