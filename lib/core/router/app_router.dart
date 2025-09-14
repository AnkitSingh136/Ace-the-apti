import 'package:ace_the_apti/features/auth/data/repositories/auth_repository.dart';
import 'package:ace_the_apti/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:ace_the_apti/features/auth/presentation/screens/login_screen.dart';
import 'package:ace_the_apti/features/auth/presentation/screens/signup_screen.dart';
import 'package:ace_the_apti/features/auth/presentation/screens/splash_screen.dart';
import 'package:ace_the_apti/features/home/presentation/screens/home_screen.dart';
import 'package:ace_the_apti/features/practice/presentation/screens/question_screen.dart';
import 'package:ace_the_apti/features/practice/presentation/screens/results_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Using a Provider for the router to allow it to listen to other providers.
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: SplashScreen.routeName,
    routes: [
      GoRoute(
        path: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: SignUpScreen.routeName,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: ForgotPasswordScreen.routeName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: HomeScreen.routeName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: QuestionScreen.routeName,
        builder: (context, state) => const QuestionScreen(),
      ),
      GoRoute(
        path: ResultsScreen.routeName,
        builder: (context, state) => const ResultsScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      // Use the latest auth state to make decisions.
      final User? user = authState.asData?.value;
      final bool loggingIn = state.matchedLocation == LoginScreen.routeName ||
                             state.matchedLocation == SignUpScreen.routeName ||
                             state.matchedLocation == ForgotPasswordScreen.routeName ||
                             state.matchedLocation == SplashScreen.routeName;

      if (user == null) {
        // User is not logged in, redirect to login screen if not already there.
        return loggingIn ? null : LoginScreen.routeName;
      }

      if (loggingIn) {
        // User is logged in, redirect from auth screens to home screen.
        return HomeScreen.routeName;
      }

      // No redirect needed.
      return null;
    },
  );
});
