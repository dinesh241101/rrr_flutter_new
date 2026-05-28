class QuizModel {
  final String id;
  final String title;
  final String? description;
  final String? genre;
  final String? imageUrl;
  final int entryFee;
  final int coinsPerCorrect;
  final int totalQuestions;
  final int timePerQuestion;
  final bool isActive;
  final String quizType;

  QuizModel({
    required this.id,
    required this.title,
    this.description,
    this.genre,
    this.imageUrl,
    required this.entryFee,
    required this.coinsPerCorrect,
    required this.totalQuestions,
    required this.timePerQuestion,
    required this.isActive,
    required this.quizType,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      genre: json['genre'],
      imageUrl: json['image_url'],
      entryFee: json['entry_fee'] ?? 0,
      coinsPerCorrect: json['coins_per_correct'] ?? 0,
      totalQuestions: json['total_questions'] ?? 0,
      timePerQuestion: json['time_per_question'] ?? 10,
      isActive: json['is_active'] ?? false,
      quizType: json['quiz_type'] ?? 'normal',
    );
  }
}