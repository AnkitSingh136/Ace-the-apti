import 'package:cloud_firestore/cloud_firestore.dart';

enum QuestionDifficulty { easy, medium, hard }

class Question {
  final String id;
  final String category;
  final QuestionDifficulty difficulty;
  final String questionText;
  final List<String> options;
  final String correctAnswer;
  final String explanation;

  Question({
    required this.id,
    required this.category,
    required this.difficulty,
    required this.questionText,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Question(
      id: doc.id,
      category: data['category'] ?? '',
      difficulty: _parseDifficulty(data['difficulty'] ?? 'easy'),
      questionText: data['questionText'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
      explanation: data['explanation'] ?? '',
    );
  }

  static QuestionDifficulty _parseDifficulty(String difficultyStr) {
    switch (difficultyStr.toLowerCase()) {
      case 'easy':
        return QuestionDifficulty.easy;
      case 'medium':
        return QuestionDifficulty.medium;
      case 'hard':
        return QuestionDifficulty.hard;
      default:
        return QuestionDifficulty.easy;
    }
  }
}
