import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CoinCounter extends ConsumerWidget {
  const CoinCounter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          Icon(Icons.monetization_on, color: Colors.amber.shade300, size: 24),
          const SizedBox(width: 8),
          userAsyncValue.when(
            data: (user) => Text(
              user?.coins.toString() ?? '0',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            loading: () => const Text(
              '...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            error: (err, stack) => Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}
