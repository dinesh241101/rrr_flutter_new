class QuestionModel {
  final String id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int correctAnswer;
  final int points;
  final String? imageUrl;
  final String? category;
  final String? difficulty;

  QuestionModel({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    required this.points,
    this.imageUrl,
    this.category,
    this.difficulty,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      question: json['question'] ?? '',
      optionA: json['option_a'],
      optionB: json['option_b'],
      optionC: json['option_c'],
      optionD: json['option_d'],
      correctAnswer: json['correct_answer'],
      points: json['points'] ?? 10,
      imageUrl: json['image_url'],
      category: json['category'],
      difficulty: json['difficulty'],
    );
  }
}