import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/theme/app_theme.dart';
import 'package:rrr_flutter_new/models/supabase_models.dart';
import 'package:rrr_flutter_new/models/quiz_question.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/screens/quizistan/quiz_result_screen.dart';

class QuizPlayScreen extends StatefulWidget {
  final QuizistanQuiz quiz;
  final List<QuizQuestion> questions;

  const QuizPlayScreen({
    super.key,
    required this.quiz,
    required this.questions,
  });

  @override
  State<QuizPlayScreen> createState() => _QuizPlayScreenState();
}

class _QuizPlayScreenState extends State<QuizPlayScreen> {
  int _currentIndex = 0;
  int _correctAnswers = 0;
  int? _selectedOptionIndex;
  bool _isAnswered = false;
  late int _timeLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.quiz.timePerQuestion;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = widget.quiz.timePerQuestion;
      _selectedOptionIndex = null;
      _isAnswered = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _revealAnswer(null); // Time out
      }
    });
  }

  void _revealAnswer(int? optionIndex) {
    if (_isAnswered) return;
    _timer?.cancel();

    final currentQuestion = widget.questions[_currentIndex];
    final bool correct = optionIndex != null && optionIndex == currentQuestion.correctIndex;

    setState(() {
      _selectedOptionIndex = optionIndex;
      _isAnswered = true;
      if (correct) {
        _correctAnswers++;
      }
    });
  }

  void _onNext() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _startTimer();
    } else {
      // Quiz completed!
      final coinsEarned = _correctAnswers * widget.quiz.coinsPerCorrect;
      
      // Add coins to wallet
      if (coinsEarned > 0) {
        context.read<WalletProvider>().addCoins(
          amount: coinsEarned,
          source: 'Quiz Won: ${widget.quiz.title}',
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            quiz: widget.quiz,
            totalQuestions: widget.questions.length,
            correctAnswers: _correctAnswers,
            coinsEarned: coinsEarned,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[_currentIndex];
    final totalQuestions = widget.questions.length;
    final progress = (_currentIndex + 1) / totalQuestions;
    final coinBalance = context.watch<WalletProvider>().coins;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.quiz.title),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // Progress indicator & text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentIndex + 1}/$totalQuestions',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Win ${widget.quiz.coinsPerCorrect * totalQuestions} Coins',
                      style: const TextStyle(
                        color: AppTheme.secondaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white10,
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(4),
                minHeight: 6,
              ),
              const SizedBox(height: 25),

              // Circular Timer Widget
              Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: _timeLeft / widget.quiz.timePerQuestion,
                        strokeWidth: 6,
                        backgroundColor: Colors.white10,
                        color: _timeLeft <= 5 ? AppTheme.errorColor : AppTheme.primaryColor,
                      ),
                      Text(
                        '$_timeLeft',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _timeLeft <= 5 ? AppTheme.errorColor : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Question text
              Card(
                color: AppTheme.cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    currentQuestion.prompt,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Multiple Choice Options
              Expanded(
                child: ListView.builder(
                  itemCount: currentQuestion.options.length,
                  itemBuilder: (context, index) {
                    final optionLabel = String.fromCharCode(65 + index); // A, B, C, D
                    final optionText = currentQuestion.options[index];
                    
                    Color cardBorderColor = Colors.white12;
                    Color cardBgColor = AppTheme.cardColor;
                    Widget? trailingWidget;

                    if (_isAnswered) {
                      if (index == currentQuestion.correctIndex) {
                        cardBorderColor = AppTheme.successColor;
                        cardBgColor = AppTheme.successColor.withOpacity(0.1);
                        trailingWidget = const Icon(Icons.check_circle, color: AppTheme.successColor);
                      } else if (index == _selectedOptionIndex) {
                        cardBorderColor = AppTheme.errorColor;
                        cardBgColor = AppTheme.errorColor.withOpacity(0.1);
                        trailingWidget = const Icon(Icons.cancel, color: AppTheme.errorColor);
                      }
                    }

                    return GestureDetector(
                      onTap: _isAnswered ? null : () => _revealAnswer(index),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: cardBorderColor, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _isAnswered && index == currentQuestion.correctIndex
                                    ? AppTheme.successColor
                                    : (_isAnswered && index == _selectedOptionIndex
                                        ? AppTheme.errorColor
                                        : Colors.white.withOpacity(0.08)),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                optionLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                optionText,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            if (trailingWidget != null) trailingWidget,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isAnswered ? _onNext : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      disabledBackgroundColor: Colors.white10,
                      disabledForegroundColor: Colors.white30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _currentIndex == totalQuestions - 1 ? 'Finish' : 'Next',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
