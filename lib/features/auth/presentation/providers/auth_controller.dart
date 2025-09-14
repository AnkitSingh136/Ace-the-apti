import 'dart:async';
import 'package:ace_the_apti/features/auth/data/repositories/auth_repository.dart';
import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:ace_the_apti/features/auth/domain/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for the AuthController
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(userRepositoryProvider),
  );
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthController(this._authRepository, this._userRepository) : super(false);

  // Sign up with email, password, and name
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final userCredential = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          coins: 0, // Start with 0 coins
          createdAt: Timestamp.now(),
        );
        await _userRepository.createUser(newUser);
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      await _authRepository.signInWithEmail(email: email, password: password);
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle({required Function(String) onError}) async {
    state = true;
    try {
      final userCredential = await _authRepository.signInWithGoogle();
      if (userCredential != null && userCredential.user != null) {
        final user = userCredential.user!;
        // Check if user already exists in Firestore
        final userDoc = await _userRepository.getUser(user.uid);
        if (userDoc == null) {
          // New user, create a document in Firestore
          final newUser = UserModel(
            uid: user.uid,
            name: user.displayName ?? 'No Name',
            email: user.email!,
            coins: 0,
            createdAt: Timestamp.now(),
            avatarUrl: user.photoURL,
          );
          await _userRepository.createUser(newUser);
        }
      }
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({
    required String email,
    required Function(String) onError,
    required Function() onSuccess,
  }) async {
    state = true;
    try {
      await _authRepository.sendPasswordResetEmail(email: email);
      onSuccess();
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}
