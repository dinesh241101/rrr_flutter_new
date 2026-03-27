import 'package:flutter/foundation.dart';
import 'package:rrr_flutter_new/models/quiz_question.dart';

class QuizProvider extends ChangeNotifier {
  QuizProvider({required List<QuizQuestion> questions})
    : _questions = List<QuizQuestion>.unmodifiable(questions);

  final List<QuizQuestion> _questions;
  int _currentIndex = 0;
  int _correctAnswers = 0;
  bool _completed = false;

  List<QuizQuestion> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get correctAnswers => _correctAnswers;
  bool get completed => _completed;

  QuizQuestion get currentQuestion => _questions[_currentIndex];
  int get totalQuestions => _questions.length;
  int get answeredCount => _completed ? totalQuestions : _currentIndex;

  bool answerCurrent(int optionIndex) {
    if (_completed) {
      return false;
    }
    final bool isCorrect = currentQuestion.correctIndex == optionIndex;
    if (isCorrect) {
      _correctAnswers += 1;
    }

    if (_currentIndex >= _questions.length - 1) {
      _completed = true;
    } else {
      _currentIndex += 1;
    }
    notifyListeners();
    return isCorrect;
  }

  void restart() {
    _currentIndex = 0;
    _correctAnswers = 0;
    _completed = false;
    notifyListeners();
  }
}
