import 'package:ace_the_apti/features/practice/domain/models/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for the PracticeRepository
final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  return PracticeRepository(FirebaseFirestore.instance);
});

class PracticeRepository {
  final FirebaseFirestore _firestore;

  PracticeRepository(this._firestore);

  CollectionReference get _questions => _firestore.collection('questions');
  CollectionReference get _testSeries => _firestore.collection('testSeries');

  // Fetch a set of questions for a given category.
  // The business logic of selecting 10 of each difficulty will be handled
  // in the controller/provider that calls this method.
  Future<List<Question>> getQuestionsForCategory(String category) async {
    try {
      final querySnapshot = await _questions
          .where('category', isEqualTo: category)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs
          .map((doc) => Question.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch questions: ${e.message}');
    }
  }

  // Fetch all questions for the test series.
  Future<List<Question>> getTestSeriesQuestions() async {
    try {
      final querySnapshot = await _testSeries.get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      return querySnapshot.docs
          .map((doc) => Question.fromFirestore(doc))
          .toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch test series questions: ${e.message}');
    }
  }
}
