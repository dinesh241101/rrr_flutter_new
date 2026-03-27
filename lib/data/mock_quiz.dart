import 'package:rrr_flutter_new/models/quiz_question.dart';

class MockQuizData {
  MockQuizData._();

  static const List<QuizQuestion> questions = <QuizQuestion>[
    QuizQuestion(
      id: 'q1',
      prompt: 'Which language is used to build Flutter apps?',
      options: <String>['Kotlin', 'Swift', 'Dart', 'TypeScript'],
      correctIndex: 2,
    ),
    QuizQuestion(
      id: 'q2',
      prompt: 'What does DAU stand for?',
      options: <String>[
        'Daily Active Users',
        'Data Access Utility',
        'Direct App Usage',
        'Dynamic Average Unit',
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      id: 'q3',
      prompt: 'Which ad type gives bonus rewards after watching?',
      options: <String>[
        'Banner',
        'Rewarded',
        'Native',
        'Splash',
      ],
      correctIndex: 1,
    ),
    QuizQuestion(
      id: 'q4',
      prompt: 'What is a common retention checkpoint?',
      options: <String>['Day 1', 'Year 5', 'Quarter 8', 'Hour 100'],
      correctIndex: 0,
    ),
    QuizQuestion(
      id: 'q5',
      prompt: 'Which store is used for app state in this scaffold?',
      options: <String>['BLoC', 'Redux', 'MobX', 'Provider'],
      correctIndex: 3,
    ),
  ];
}
