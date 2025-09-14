import 'package:ace_the_apti/features/auth/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider to expose the UserRepository instance
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(FirebaseFirestore.instance);
});

// Provider to get user details for the currently logged-in user
final userProvider = FutureProvider<UserModel?>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final currentUser = authRepository.currentUser;
  if (currentUser != null) {
    return await userRepository.getUser(currentUser.uid);
  }
  return null;
});


class UserRepository {
  final FirebaseFirestore _firestore;

  UserRepository(this._firestore);

  CollectionReference get _users => _firestore.collection('users');

  // Create a new user document in Firestore
  Future<void> createUser(UserModel user) async {
    try {
      await _users.doc(user.uid).set(user.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Failed to create user in Firestore: ${e.message}');
    }
  }

  // Get a user document from Firestore
  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await _users.doc(uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get user from Firestore: ${e.message}');
    }
  }

  // Update user data (e.g., name, avatar, coins)
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _users.doc(uid).update(data);
    } on FirebaseException catch (e) {
      throw Exception('Failed to update user: ${e.message}');
    }
  }
}
