import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/models/question_model.dart';
import 'package:rrr_flutter_new/models/quiz_model.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/quizistan/quiz_play_screen.dart';
import 'package:rrr_flutter_new/services/quiz_service.dart';
import 'package:rrr_flutter_new/models/question_model.dart';
import 'package:rrr_flutter_new/models/quiz_model.dart';

class QuizistanScreen extends StatefulWidget {
  const QuizistanScreen({super.key});

  @override
  State<QuizistanScreen> createState() => _QuizistanScreenState();
}

class _QuizistanScreenState extends State<QuizistanScreen> {

  final QuizService _quizService = QuizService();

  bool _loading = true;
  bool _startingQuiz = false;

  String _selectedCategory = 'All';

  List<String> _categories = ['All'];

  List<QuizModel> _allQuizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  /// FETCH QUIZZES + CATEGORIES
  Future<void> _loadQuizData() async {

    try {

      setState(() => _loading = true);

      final quizzes = await _quizService.fetchQuizzes();

      final genres = quizzes
          .map((e) => e.genre ?? 'General')
          .toSet()
          .toList();

      if (!mounted) return;

      setState(() {
        _allQuizzes = quizzes;
        _categories = ['All', ...genres];
        _loading = false;
      });

    } catch (e) {

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load quizzes: $e'),
        ),
      );
    }
  }

  /// START QUIZ
  Future<void> _startQuiz(QuizModel quiz) async {

    if (_startingQuiz) return;

    final wallet = context.read<WalletProvider>();

    if (wallet.coins < quiz.entryFee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough coins!'),
        ),
      );
      return;
    }

    try {

      setState(() => _startingQuiz = true);

      /// FETCH QUESTIONS
      final List<QuestionModel> questions =
      await _quizService.fetchQuestions(quiz.id);

      if (questions.isEmpty) {

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No questions available'),
          ),
        );

        return;
      }

      /// DEDUCT ENTRY
      wallet.spendCoins(
        amount: quiz.entryFee,
        source: 'Quiz Entry: ${quiz.title}',
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => QuizPlayScreen(
            quiz: quiz,
            questions: questions,
          ),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start quiz: $e'),
        ),
      );

    } finally {

      if (mounted) {
        setState(() => _startingQuiz = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final coinBalance = context.watch<WalletProvider>().coins;

    final filteredQuizzes = _selectedCategory == 'All'
        ? _allQuizzes
        : _allQuizzes
        .where((q) => q.genre == _selectedCategory)
        .toList();

    return Scaffold(

      backgroundColor: AppTheme.backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'Quizistan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [

          /// COIN BALANCE
          Container(
            margin: const EdgeInsets.only(
              right: 16,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppTheme.secondaryColor.withOpacity(0.4),
              ),
            ),
            child: Row(
              children: [

                const Icon(
                  Icons.monetization_on,
                  color: AppTheme.secondaryColor,
                  size: 18,
                ),

                const SizedBox(width: 6),

                Text(
                  '$coinBalance',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(

        onRefresh: _loadQuizData,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            /// CATEGORIES
            SizedBox(
              height: 42,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,

                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                itemCount: _categories.length,

                itemBuilder: (context, index) {

                  final cat = _categories[index];

                  final isSelected =
                      cat == _selectedCategory;

                  return GestureDetector(

                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },

                    child: AnimatedContainer(

                      duration:
                      const Duration(milliseconds: 250),

                      margin: const EdgeInsets.only(
                        right: 10,
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),

                      decoration: BoxDecoration(

                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.cardColor,

                        borderRadius:
                        BorderRadius.circular(20),

                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: AppTheme.primaryColor
                                .withOpacity(0.5),
                            blurRadius: 12,
                          )
                        ]
                            : [],

                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.white10,
                        ),
                      ),

                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            /// QUIZ LIST
            Expanded(

              child: filteredQuizzes.isEmpty

                  ? const Center(
                child: Text(
                  'No quizzes available',
                  style: TextStyle(
                    color: Colors.white54,
                  ),
                ),
              )

                  : ListView.builder(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 16,
                ),

                itemCount:
                filteredQuizzes.length,

                itemBuilder: (context, index) {

                  final quiz =
                  filteredQuizzes[index];

                  final totalWin =
                      quiz.coinsPerCorrect *
                          quiz.totalQuestions;

                  return GestureDetector(

                    onTap: _startingQuiz
                        ? null
                        : () => _startQuiz(quiz),

                    child: Container(

                      margin:
                      const EdgeInsets.only(
                        bottom: 16,
                      ),

                      decoration: BoxDecoration(

                        color: AppTheme.cardColor,

                        borderRadius:
                        BorderRadius.circular(18),

                        border: Border.all(
                          color: Colors.white10,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.2),
                            blurRadius: 10,
                          ),
                        ],
                      ),

                      child: Padding(

                        padding:
                        const EdgeInsets.all(16),

                        child: Row(
                          children: [

                            /// QUIZ IMAGE
                            Container(

                              width: 70,
                              height: 70,

                              decoration:
                              BoxDecoration(

                                borderRadius:
                                BorderRadius.circular(16),

                                image: quiz.imageUrl !=
                                    null &&
                                    quiz.imageUrl!
                                        .isNotEmpty
                                    ? DecorationImage(
                                  image:
                                  NetworkImage(
                                    quiz.imageUrl!,
                                  ),
                                  fit: BoxFit.cover,
                                )
                                    : null,

                                gradient:
                                quiz.imageUrl == null
                                    ? const LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.blue,
                                  ],
                                )
                                    : null,
                              ),

                              child: quiz.imageUrl == null
                                  ? const Icon(
                                Icons.quiz,
                                color: Colors.white,
                                size: 32,
                              )
                                  : null,
                            ),

                            const SizedBox(width: 16),

                            /// DETAILS
                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                CrossAxisAlignment.start,

                                children: [

                                  Text(
                                    quiz.title,
                                    style:
                                    const TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    quiz.description ??
                                        '',
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style:
                                    const TextStyle(
                                      color:
                                      Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Wrap(
                                    spacing: 10,
                                    runSpacing: 6,
                                    children: [

                                      _chip(
                                        Icons.timer,
                                        '${quiz.timePerQuestion}s',
                                      ),

                                      _chip(
                                        Icons.help_outline,
                                        '${quiz.totalQuestions} Q',
                                      ),

                                      _chip(
                                        Icons.workspace_premium,
                                        '${quiz.genre}',
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  Row(
                                    children: [

                                      const Icon(
                                        Icons.monetization_on,
                                        color: AppTheme.secondaryColor,
                                        size: 16,
                                      ),

                                      const SizedBox(width: 4),

                                      Text(
                                        'Win $totalWin',
                                        style:
                                        const TextStyle(
                                          color:
                                          AppTheme.secondaryColor,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),
                                      ),

                                      const Spacer(),

                                      Text(
                                        'Entry ${quiz.entryFee}',
                                        style:
                                        const TextStyle(
                                          color:
                                          Colors.white60,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Widget _chip(
      IconData icon,
      String text,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 13,
            color: AppTheme.primaryColor,
          ),

          const SizedBox(width: 5),

          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}