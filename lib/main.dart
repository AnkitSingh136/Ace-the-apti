import 'package:ace_the_apti/core/firebase/firebase_options.dart';
import 'package:ace_the_apti/core/router/app_router.dart';
import 'package:ace_the_apti/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  // Ensure that widget binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // IMPORTANT: You must generate your own firebase_options.dart file
  // by running `flutterfire configure` in your project root.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Wrap the entire app in a ProviderScope to enable Riverpod
    const ProviderScope(
      child: AceTheAptiApp(),
    ),
  );
}

class AceTheAptiApp extends ConsumerWidget {
  const AceTheAptiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider to get the GoRouter instance
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'AceTheApti',
      // Set the light theme data
      theme: AppTheme.lightTheme,
      // Set the dark theme data
      darkTheme: AppTheme.darkTheme,
      // Use the system's theme mode preference
      themeMode: ThemeMode.system,
      // Provide the router configuration
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
