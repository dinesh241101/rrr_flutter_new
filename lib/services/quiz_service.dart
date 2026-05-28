import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/question_model.dart';
import '../models/quiz_model.dart';

class QuizService {

  final supabase = Supabase.instance.client;

  /// FETCH ALL ACTIVE QUIZZES
  Future<List<QuizModel>> fetchQuizzes() async {

    final response = await supabase
        .from('quizistan_quizzes')
        .select()
        .eq('is_active', true)
        .eq('is_app_active', true)
        .order('created_at', ascending: false);

    return (response as List)
        .map((e) => QuizModel.fromJson(e))
        .toList();
  }

  /// FETCH QUESTIONS
  Future<List<QuestionModel>> fetchQuestions(
      String quizId,
      ) async {

    final response = await supabase
        .from('quiz_questions')
        .select()
        .eq('quiz_id', quizId)
        .order('order_index');

    return (response as List)
        .map((e) => QuestionModel.fromJson(e))
        .toList();
  }

  /// GET QUIZ CATEGORIES
  Future<List<String>> fetchCategories() async {

    final response = await supabase
        .from('quizistan_quizzes')
        .select('genre')
        .eq('is_active', true);

    final genres = response
        .map<String>((e) => e['genre'].toString())
        .toSet()
        .toList();

    return ['All', ...genres];
  }
}