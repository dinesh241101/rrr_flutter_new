// Game Score Model
class GameScore {
  final String id;
  final String userId;
  final String gameId;
  final String gameName;
  final int score;
  final int? timeTaken;
  final DateTime createdAt;

  GameScore({
    required this.id,
    required this.userId,
    required this.gameId,
    required this.gameName,
    required this.score,
    this.timeTaken,
    required this.createdAt,
  });

  factory GameScore.fromJson(Map<String, dynamic> json) {
    return GameScore(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      gameId: json['game_id'] as String,
      gameName: json['game_name'] as String,
      score: json['score'] as int? ?? 0,
      timeTaken: json['time_taken'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'game_id': gameId,
    'game_name': gameName,
    'score': score,
    'time_taken': timeTaken,
    'created_at': createdAt.toIso8601String(),
  };
}

class UserDetails {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;

  UserDetails({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }
}

// Game Config Model
class GameConfig {
  final String id;
  final String gameId;
  final String gameName;
  final int entryFee;
  final bool isActive;
  final int tier1Reward;
  final int tier2Reward;
  final int tier3Reward;
  final int tier4Reward;
  final int minScoreTier1;
  final int minScoreTier2;
  final int minScoreTier3;
  final int minScoreTier4;

  GameConfig({
    required this.id,
    required this.gameId,
    required this.gameName,
    required this.entryFee,
    required this.isActive,
    required this.tier1Reward,
    required this.tier2Reward,
    required this.tier3Reward,
    required this.tier4Reward,
    required this.minScoreTier1,
    required this.minScoreTier2,
    required this.minScoreTier3,
    required this.minScoreTier4,
  });

  factory GameConfig.fromJson(Map<String, dynamic> json) {
    return GameConfig(
      id: json['id'] as String,
      gameId: json['game_id'] as String,
      gameName: json['game_name'] as String,
      entryFee: json['entry_fee'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      tier1Reward: json['tier_1_reward'] as int? ?? 0,
      tier2Reward: json['tier_2_reward'] as int? ?? 0,
      tier3Reward: json['tier_3_reward'] as int? ?? 0,
      tier4Reward: json['tier_4_reward'] as int? ?? 0,
      minScoreTier1: json['min_score_tier_1'] as int? ?? 0,
      minScoreTier2: json['min_score_tier_2'] as int? ?? 0,
      minScoreTier3: json['min_score_tier_3'] as int? ?? 0,
      minScoreTier4: json['min_score_tier_4'] as int? ?? 0,
    );
  }
}

// Coin Transaction Model
class CoinTransaction {
  final String id;
  final String userId;
  final int amount;
  final String type; // 'earn' or 'spend'
  final String reason;
  final String? gameId;
  final String? gameName;
  final DateTime createdAt;

  CoinTransaction({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.reason,
    this.gameId,
    this.gameName,
    required this.createdAt,
  });

  factory CoinTransaction.fromJson(Map<String, dynamic> json) {
    return CoinTransaction(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: json['amount'] as int? ?? 0,
      type: json['type'] as String? ?? 'earn',
      reason: json['reason'] as String,
      gameId: json['game_id'] as String?,
      gameName: json['game_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// Quizistan Quiz Model
class QuizistanQuiz {
  final String id;
  final String title;
  final String description;
  final String genre;
  final String quizType;
  final int totalQuestions;
  final int entryFee;
  final int coinsPerCorrect;
  final String? imageUrl;
  final bool isActive;
  final int timePerQuestion;
  final String? startTime;
  final String? endTime;
  final DateTime createdAt;

  QuizistanQuiz({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.quizType,
    required this.totalQuestions,
    required this.entryFee,
    required this.coinsPerCorrect,
    this.imageUrl,
    required this.isActive,
    required this.timePerQuestion,
    this.startTime,
    this.endTime,
    required this.createdAt,
  });

  factory QuizistanQuiz.fromJson(Map<String, dynamic> json) {
    return QuizistanQuiz(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      genre: json['genre'] as String? ?? '',
      quizType: json['quiz_type'] as String? ?? 'general',
      totalQuestions: json['total_questions'] as int? ?? 0,
      entryFee: json['entry_fee'] as int? ?? 0,
      coinsPerCorrect: json['coins_per_correct'] as int? ?? 10,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      timePerQuestion: json['time_per_question'] as int? ?? 30,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

// Quizistan Attempt Model
class QuizistanAttempt {
  final String id;
  final String userId;
  final String quizId;
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final int coinsEarned;
  final int? timeTaken;
  final int streakCount;
  final String? tierName;
  final DateTime completedAt;

  QuizistanAttempt({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.coinsEarned,
    this.timeTaken,
    required this.streakCount,
    this.tierName,
    required this.completedAt,
  });

  factory QuizistanAttempt.fromJson(Map<String, dynamic> json) {
    return QuizistanAttempt(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      quizId: json['quiz_id'] as String,
      score: json['score'] as int? ?? 0,
      correctAnswers: json['correct_answers'] as int? ?? 0,
      totalQuestions: json['total_questions'] as int? ?? 0,
      coinsEarned: json['coins_earned'] as int? ?? 0,
      timeTaken: json['time_taken'] as int?,
      streakCount: json['streak_count'] as int? ?? 0,
      tierName: json['tier_name'] as String?,
      completedAt: DateTime.parse(json['completed_at'] as String),
    );
  }
}

class Usercoins {
  final String userId;
  final int balance;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int spentCoins;
  final int earnedCoins;

  Usercoins({
    required this.userId,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    required this.spentCoins,
    required this.earnedCoins,
  });

  factory Usercoins.fromJson(Map<String, dynamic> json) {
    return Usercoins(
      userId: json['user_id'] as String,
      balance: json['balance'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      spentCoins: json['spent_coins'] as int? ?? 0,
      earnedCoins: json['earned_coins'] as int? ?? 0,
    );
  }
}
