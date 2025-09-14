import 'package:ace_the_apti/features/auth/data/repositories/auth_repository.dart';
import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:ace_the_apti/features/practice/data/repositories/practice_repository.dart';
import 'package:ace_the_apti/features/practice/domain/models/question_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum PracticeStatus { initial, loading, success, error, complete }

@immutable
class PracticeState {
  final PracticeStatus status;
  final List<Question> questions;
  final int currentIndex;
  final Map<String, String> answers; // Map<questionId, selectedOption>
  final int score;
  final int coinsEarned;
  final String? error;

  const PracticeState({
    this.status = PracticeStatus.initial,
    this.questions = const [],
    this.currentIndex = 0,
    this.answers = const {},
    this.score = 0,
    this.coinsEarned = 0,
    this.error,
  });

  PracticeState copyWith({
    PracticeStatus? status,
    List<Question>? questions,
    int? currentIndex,
    Map<String, String>? answers,
    int? score,
    int? coinsEarned,
    String? error,
  }) {
    return PracticeState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      answers: answers ?? this.answers,
      score: score ?? this.score,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      error: error ?? this.error,
    );
  }
}

final practiceControllerProvider =
    StateNotifierProvider<PracticeController, PracticeState>((ref) {
  return PracticeController(
    ref.watch(practiceRepositoryProvider),
    ref.watch(userRepositoryProvider),
    ref.watch(authRepositoryProvider),
  );
});

class PracticeController extends StateNotifier<PracticeState> {
  final PracticeRepository _practiceRepository;
  final UserRepository _userRepository;
  final AuthRepository _authRepository;

  PracticeController(
    this._practiceRepository,
    this._userRepository,
    this._authRepository,
  ) : super(const PracticeState());

  Future<void> startPractice(String category) async {
    state = state.copyWith(status: PracticeStatus.loading);
    try {
      final allQuestions = await _practiceRepository.getQuestionsForCategory(category);

      final easy = allQuestions.where((q) => q.difficulty == QuestionDifficulty.easy).toList()..shuffle();
      final medium = allQuestions.where((q) => q.difficulty == QuestionDifficulty.medium).toList()..shuffle();
      final hard = allQuestions.where((q) => q.difficulty == QuestionDifficulty.hard).toList()..shuffle();

      final practiceQuestions = [
        ...easy.take(10),
        ...medium.take(10),
        ...hard.take(10),
      ]..shuffle();

      if (practiceQuestions.isEmpty) {
        throw Exception('No questions found for this category.');
      }

      state = state.copyWith(
        status: PracticeStatus.success,
        questions: practiceQuestions,
        currentIndex: 0,
        answers: {},
        score: 0,
        coinsEarned: 0,
      );
    } catch (e) {
      state = state.copyWith(status: PracticeStatus.error, error: e.toString());
    }
  }

  void submitAnswer(String questionId, String answer) {
    final newAnswers = Map<String, String>.from(state.answers);
    newAnswers[questionId] = answer;
    state = state.copyWith(answers: newAnswers);

    if (state.currentIndex < state.questions.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    } else {
      _completePractice();
    }
  }

  void _completePractice() {
    int finalScore = 0;
    int coins = 0;
    for (final question in state.questions) {
      if (state.answers[question.id] == question.correctAnswer) {
        finalScore++;
        switch (question.difficulty) {
          case QuestionDifficulty.easy:
            coins += 5;
            break;
          case QuestionDifficulty.medium:
            coins += 10;
            break;
          case QuestionDifficulty.hard:
            coins += 20;
            break;
        }
      }
    }

    state = state.copyWith(
      status: PracticeStatus.complete,
      score: finalScore,
      coinsEarned: coins,
    );

    // Update user's coin balance in Firestore
    _updateUserCoins(coins);
  }

  Future<void> _updateUserCoins(int coinsToAdd) async {
    try {
      final uid = _authRepository.currentUser!.uid;
      final user = await _userRepository.getUser(uid);
      if (user != null) {
        final newCoinBalance = user.coins + coinsToAdd;
        await _userRepository.updateUser(uid, {'coins': newCoinBalance});
      }
    } catch (e) {
      // Handle error, maybe log it. The user has finished the quiz,
      // so failing to add coins is a non-critical error for the UI flow.
      debugPrint("Failed to update user coins: $e");
    }
  }

  Future<void> startTestSeriesSession() async {
    state = state.copyWith(status: PracticeStatus.loading);
    try {
      final questions = await _practiceRepository.getTestSeriesQuestions();
      questions.shuffle();

      if (questions.isEmpty) {
        throw Exception('The Test Series is not available at the moment.');
      }

      state = state.copyWith(
        status: PracticeStatus.success,
        questions: questions,
        currentIndex: 0,
        answers: {},
        score: 0,
        coinsEarned: 0,
      );
    } catch (e) {
      state = state.copyWith(status: PracticeStatus.error, error: e.toString());
    }
  }

  void reset() {
    state = const PracticeState();
  }
}
