import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rrr_flutter_new/core/theme/app_theme.dart';

import 'package:rrr_flutter_new/models/question_model.dart';
import 'package:rrr_flutter_new/models/quiz_model.dart';

import 'package:rrr_flutter_new/providers/wallet_provider.dart';

import 'package:rrr_flutter_new/screens/quizistan/quiz_result_screen.dart';

import 'package:rrr_flutter_new/models/quiz_model.dart';

class QuizPlayScreen extends StatefulWidget {

  final QuizModel quiz;
  final List<QuestionModel> questions;

  const QuizPlayScreen({
    super.key,
    required this.quiz,
    required this.questions,
  });

  @override
  State<QuizPlayScreen> createState() =>
      _QuizPlayScreenState();
}

class _QuizPlayScreenState
    extends State<QuizPlayScreen> {

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

    _timer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {

        if (!mounted) return;

        if (_timeLeft > 0) {

          setState(() {
            _timeLeft--;
          });

        } else {

          _timer?.cancel();

          _revealAnswer(null);
        }
      },
    );
  }

  void _revealAnswer(int? optionIndex) {

    if (_isAnswered) return;

    _timer?.cancel();

    final currentQuestion =
    widget.questions[_currentIndex];

    final bool correct =
        optionIndex != null &&
            (optionIndex + 1) ==
                currentQuestion.correctAnswer;

    setState(() {

      _selectedOptionIndex = optionIndex;

      _isAnswered = true;

      if (correct) {
        _correctAnswers++;
      }
    });
  }

  void _onNext() {

    if (_currentIndex <
        widget.questions.length - 1) {

      setState(() {
        _currentIndex++;
      });

      _startTimer();

    } else {

      final coinsEarned =
          _correctAnswers *
              widget.quiz.coinsPerCorrect;

      if (coinsEarned > 0) {

        context.read<WalletProvider>().addCoins(
          amount: coinsEarned,
          source:
          'Quiz Won: ${widget.quiz.title}',
        );
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            quiz: widget.quiz,
            totalQuestions:
            widget.questions.length,
            correctAnswers: _correctAnswers,
            coinsEarned: coinsEarned,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final currentQuestion =
    widget.questions[_currentIndex];

    final totalQuestions =
        widget.questions.length;

    final progress =
        (_currentIndex + 1) /
            totalQuestions;

    final coinBalance =
        context.watch<WalletProvider>().coins;

    final options = [

      currentQuestion.optionA,
      currentQuestion.optionB,
      currentQuestion.optionC,
      currentQuestion.optionD,
    ];

    return Scaffold(

      appBar: AppBar(

        title: Text(widget.quiz.title),

        actions: [

          Container(

            margin:
            const EdgeInsets.only(right: 16),

            padding:
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),

            decoration: BoxDecoration(

              color:
              Colors.white.withOpacity(0.08),

              borderRadius:
              BorderRadius.circular(20),
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

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.symmetric(
            horizontal: 20,
          ),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.stretch,

            children: [

              const SizedBox(height: 16),

              /// HEADER
              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text(
                    'Question ${_currentIndex + 1}/$totalQuestions',
                  ),

                  Text(
                    'Win ${widget.quiz.coinsPerCorrect * totalQuestions}',
                    style: const TextStyle(
                      color:
                      AppTheme.secondaryColor,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              /// PROGRESS
              LinearProgressIndicator(
                value: progress,
                color: AppTheme.primaryColor,
              ),

              const SizedBox(height: 30),

              /// TIMER
              Center(
                child: Text(
                  '$_timeLeft',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: _timeLeft <= 5
                        ? AppTheme.errorColor
                        : Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// QUESTION
              Container(

                padding:
                const EdgeInsets.all(20),

                decoration: BoxDecoration(

                  color: AppTheme.cardColor,

                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: Text(

                  currentQuestion.question,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// OPTIONS
              Expanded(

                child: ListView.builder(

                  itemCount: options.length,

                  itemBuilder: (context, index) {

                    final option =
                    options[index];

                    bool isCorrect =
                        (index + 1) ==
                            currentQuestion.correctAnswer;

                    bool isSelected =
                        index ==
                            _selectedOptionIndex;

                    Color border =
                        Colors.white12;

                    if (_isAnswered) {

                      if (isCorrect) {
                        border =
                            AppTheme.successColor;
                      } else if (isSelected) {
                        border =
                            AppTheme.errorColor;
                      }
                    }

                    return GestureDetector(

                      onTap: _isAnswered
                          ? null
                          : () =>
                          _revealAnswer(index),

                      child: Container(

                        margin:
                        const EdgeInsets.only(
                          bottom: 14,
                        ),

                        padding:
                        const EdgeInsets.all(16),

                        decoration: BoxDecoration(

                          color:
                          AppTheme.cardColor,

                          borderRadius:
                          BorderRadius.circular(
                              16),

                          border: Border.all(
                            color: border,
                            width: 1.5,
                          ),
                        ),

                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              /// BUTTON
              SizedBox(

                height: 54,

                child: ElevatedButton(

                  onPressed:
                  _isAnswered ? _onNext : null,

                  child: Text(
                    _currentIndex ==
                        totalQuestions - 1
                        ? 'Finish'
                        : 'Next',
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}