import 'package:ace_the_apti/features/practice/presentation/providers/practice_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultsScreen extends ConsumerWidget {
  const ResultsScreen({super.key});

  static const routeName = '/practice/results';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practiceState = ref.watch(practiceControllerProvider);
    final practiceController = ref.read(practiceControllerProvider.notifier);

    // Invalidate the user provider to refetch the user's data with the new coin balance
    ref.invalidate(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false, // No back button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Practice Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'You Scored',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '${practiceState.score} / ${practiceState.questions.length}',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '+${practiceState.coinsEarned}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.monetization_on,
                  color: Colors.amber.shade700,
                  size: 32,
                ),
              ],
            ),
            const Text('Coins Earned'),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                // Reset the practice state and go back to the home screen's practice tab
                practiceController.reset();
                context.go('/'); // Navigate to home, which defaults to the practice screen tab
              },
              child: const Text('Back to Categories'),
            ),
          ],
        ),
      ),
    );
  }
}
