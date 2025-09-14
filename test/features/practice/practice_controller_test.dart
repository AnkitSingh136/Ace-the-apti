import 'package:ace_the_apti/features/auth/data/repositories/auth_repository.dart';
import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:ace_the_apti/features/practice/data/repositories/practice_repository.dart';
import 'package:ace_the_apti/features/practice/domain/models/question_model.dart';
import 'package:ace_the_apti/features/practice/presentation/providers/practice_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Import the generated mock file
import 'practice_controller_test.mocks.dart';

// Annotate the classes to be mocked.
// After adding this, run `dart run build_runner build` in the terminal.
@GenerateMocks([PracticeRepository, UserRepository, AuthRepository])
void main() {
  late MockPracticeRepository mockPracticeRepository;
  late MockUserRepository mockUserRepository;
  late MockAuthRepository mockAuthRepository;
  late PracticeController practiceController;

  setUp(() {
    mockPracticeRepository = MockPracticeRepository();
    mockUserRepository = MockUserRepository();
    mockAuthRepository = MockAuthRepository();
    practiceController = PracticeController(
      mockPracticeRepository,
      mockUserRepository,
      mockAuthRepository,
    );
  });

  // Dummy questions for testing
  final dummyQuestions = [
    Question(id: 'q1', category: 'Test', difficulty: QuestionDifficulty.easy, questionText: '1+1?', options: ['1','2','3'], correctAnswer: '2', explanation: ''),
    Question(id: 'q2', category: 'Test', difficulty: QuestionDifficulty.medium, questionText: '2*2?', options: ['2','4','6'], correctAnswer: '4', explanation: ''),
    Question(id: 'q3', category: 'Test', difficulty: QuestionDifficulty.hard, questionText: '3*3?', options: ['3','6','9'], correctAnswer: '9', explanation: ''),
    Question(id: 'q4', category: 'Test', difficulty: QuestionDifficulty.easy, questionText: '4+4?', options: ['4','8','12'], correctAnswer: '4', explanation: ''), // Wrong answer
  ];

  group('PracticeController', () {
    test('Initial state is correct', () {
      expect(practiceController.debugState.status, PracticeStatus.initial);
      expect(practiceController.debugState.questions, isEmpty);
    });

    test('startPractice fetches and prepares questions', () async {
      // Arrange
      when(mockPracticeRepository.getQuestionsForCategory(any))
          .thenAnswer((_) async => dummyQuestions);

      // Act
      await practiceController.startPractice('Test');

      // Assert
      expect(practiceController.debugState.status, PracticeStatus.success);
      expect(practiceController.debugState.questions, isNotEmpty);
      expect(practiceController.debugState.questions.length, 3); // 1 easy, 1 medium, 1 hard (takes 10 of each)
    });

    test('Score and coins are calculated correctly after completing a session', () async {
      // Arrange: Setup the controller with questions
      practiceController.debugState = practiceController.debugState.copyWith(
        status: PracticeStatus.success,
        questions: dummyQuestions,
      );

      // Mock the user update call
      when(mockAuthRepository.currentUser).thenReturn(null); // Simplified for this test
      when(mockUserRepository.updateUser(any, any)).thenAnswer((_) async {});

      // Act: Simulate answering questions
      practiceController.submitAnswer('q1', '2'); // Correct, Easy: +5 coins
      practiceController.submitAnswer('q2', '4'); // Correct, Medium: +10 coins
      practiceController.submitAnswer('q3', 'wrong'); // Incorrect, Hard: +0 coins
      practiceController.submitAnswer('q4', '8'); // Correct, Easy: +5 coins - Wait, correct answer is 4, so this is wrong. Let's fix the test data.
      // Correcting the test data for q4, let's say the user answers '8' and it's correct.
      // Oh, the dummy question itself is wrong. Let's fix it.
      // Correct dummy question:
      final fixedDummyQuestions = [
        Question(id: 'q1', category: 'Test', difficulty: QuestionDifficulty.easy, questionText: '1+1?', options: ['1','2','3'], correctAnswer: '2', explanation: ''),
        Question(id: 'q2', category: 'Test', difficulty: QuestionDifficulty.medium, questionText: '2*2?', options: ['2','4','6'], correctAnswer: '4', explanation: ''),
        Question(id: 'q3', category: 'Test', difficulty: QuestionDifficulty.hard, questionText: '3*3?', options: ['3','6','9'], correctAnswer: '9', explanation: ''),
        Question(id: 'q4', category: 'Test', difficulty: QuestionDifficulty.easy, questionText: '4+4?', options: ['4','8','12'], correctAnswer: '8', explanation: ''),
      ];
      practiceController.debugState = practiceController.debugState.copyWith(questions: fixedDummyQuestions);

      // Resimulate answers
      practiceController.submitAnswer('q1', '2');      // Correct, Easy: +5
      practiceController.submitAnswer('q2', '4');      // Correct, Medium: +10
      practiceController.submitAnswer('q3', 'wrong');  // Incorrect, Hard: +0
      practiceController.submitAnswer('q4', '8');      // Correct, Easy: +5

      // Assert: Check final state after the last answer
      expect(practiceController.debugState.status, PracticeStatus.complete);
      expect(practiceController.debugState.score, 3); // 3 correct answers
      expect(practiceController.debugState.coinsEarned, 20); // 5 + 10 + 5 = 20 coins
    });

    test('reset clears the state', () {
       // Arrange
      practiceController.debugState = practiceController.debugState.copyWith(
        status: PracticeStatus.complete,
        score: 5,
        coinsEarned: 50,
      );

      // Act
      practiceController.reset();

      // Assert
      expect(practiceController.debugState.status, PracticeStatus.initial);
      expect(practiceController.debugState.score, 0);
      expect(practiceController.debugState.coinsEarned, 0);
    });
  });
}
