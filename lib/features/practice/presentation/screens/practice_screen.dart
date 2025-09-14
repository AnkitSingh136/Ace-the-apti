import 'package:ace_the_apti/features/practice/presentation/providers/practice_controller.dart';
import 'package:ace_the_apti/features/practice/presentation/screens/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the practice controller state changes for navigation
    ref.listen<PracticeState>(practiceControllerProvider, (previous, next) {
      if (next.status == PracticeStatus.success) {
        // Navigate to the question screen when practice is successfully started
        context.push(QuestionScreen.routeName);
      }
      if (next.status == PracticeStatus.error) {
        // Show an error message if something goes wrong
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error ?? 'An unknown error occurred')),
        );
      }
    });

    final practiceState = ref.watch(practiceControllerProvider);

    return Scaffold(
      body: practiceState.status == PracticeStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Choose a Category',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 32),
                  _CategoryCard(
                    title: 'Quantitative',
                    icon: Icons.calculate,
                    onTap: () => ref.read(practiceControllerProvider.notifier).startPractice('Quantitative'),
                  ),
                  _CategoryCard(
                    title: 'Logical Reasoning',
                    icon: Icons.lightbulb,
                    onTap: () => ref.read(practiceControllerProvider.notifier).startPractice('Logical Reasoning'),
                  ),
                  _CategoryCard(
                    title: 'Analogy',
                    icon: Icons.compare_arrows,
                    onTap: () => ref.read(practiceControllerProvider.notifier).startPractice('Analogy'),
                  ),
                ],
              ),
            ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Theme.of(context).primaryColor),
              const SizedBox(width: 24),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}
