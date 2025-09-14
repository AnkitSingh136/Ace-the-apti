import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:ace_the_apti/features/practice/presentation/providers/practice_controller.dart';
import 'package:ace_the_apti/features/practice/presentation/screens/question_screen.dart';
import 'package:ace_the_apti/features/test_series/presentation/providers/test_series_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// This screen acts as a gatekeeper for the premium Test Series feature.
/// It displays a "locked" view if the user has not unlocked the feature,
/// and an "unlocked" view if they have. The unlocking is handled by the
/// [TestSeriesController].
class TestSeriesScreen extends ConsumerWidget {
  const TestSeriesScreen({super.key});

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    final practiceState = ref.watch(practiceControllerProvider);
    final isUnlocking = ref.watch(testSeriesControllerProvider);

    // Listen to the practice controller to navigate when the test series starts.
    ref.listen<PracticeState>(practiceControllerProvider, (previous, next) {
      if (next.status == PracticeStatus.success) {
        context.push(QuestionScreen.routeName);
      } else if (next.status == PracticeStatus.error) {
        _showErrorSnackbar(context, next.error ?? 'Failed to start test series');
      }
    });

    return Scaffold(
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found.'));
          }
          // Conditionally render the UI based on the user's unlock status.
          if (user.hasUnlockedTestSeries) {
            return _buildUnlockedView(context, ref, practiceState.status == PracticeStatus.loading);
          } else {
            return _buildLockedView(context, ref, user.coins, isUnlocking);
          }
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }

  /// The view shown when the user has not yet unlocked the test series.
  Widget _buildLockedView(BuildContext context, WidgetRef ref, int userCoins, bool isUnlocking) {
    final canAfford = userCoins >= TestSeriesController.unlockCost;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 24),
            Text(
              'Unlock the Premium Test Series',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Challenge yourself with a set of mixed-difficulty questions.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${TestSeriesController.unlockCost}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.amber.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.monetization_on, color: Colors.amber.shade700, size: 32),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: canAfford && !isUnlocking
                  ? () {
                      ref.read(testSeriesControllerProvider.notifier).unlockTestSeries(
                        onError: (error) => _showErrorSnackbar(context, error),
                      );
                      // Invalidate the user provider to refetch the user's data
                      // and trigger a UI rebuild with the new coin balance and unlock status.
                      ref.invalidate(userProvider);
                    }
                  : null,
              child: isUnlocking
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Unlock Now'),
            ),
            if (!canAfford)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'You need ${TestSeriesController.unlockCost - userCoins} more coins.',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// The view shown when the user has already unlocked the test series.
  Widget _buildUnlockedView(BuildContext context, WidgetRef ref, bool isLoading) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80, color: Colors.green.shade400),
          const SizedBox(height: 24),
          Text(
            'Test Series Unlocked!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Text(
            'You\'re ready to take the test.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: isLoading ? null : () {
              ref.read(practiceControllerProvider.notifier).startTestSeriesSession();
            },
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Start Test Series'),
          ),
        ],
      ),
    );
  }
}
