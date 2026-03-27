import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rrr_flutter_new/core/constants/app_values.dart';
import 'package:rrr_flutter_new/providers/quiz_provider.dart';
import 'package:rrr_flutter_new/providers/session_provider.dart';
import 'package:rrr_flutter_new/providers/wallet_provider.dart';
import 'package:rrr_flutter_new/services/ads_service.dart';

class QuizistanScreen extends StatelessWidget {
  const QuizistanScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (BuildContext context, QuizProvider quiz, _) {
        if (quiz.completed) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Quiz Session Complete',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Score: ${quiz.correctAnswers}/${quiz.totalQuestions}',
                      ),
                      const SizedBox(height: 14),
                      FilledButton(
                        onPressed: quiz.restart,
                        child: const Text('Restart Quiz'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final question = quiz.currentQuestion;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Question ${quiz.currentIndex + 1}/${quiz.totalQuestions}',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  question.prompt,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            ...question.options.asMap().entries.map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: () => _handleAnswer(context, option.key),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(option.value),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Current Score: ${quiz.correctAnswers}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }
}
