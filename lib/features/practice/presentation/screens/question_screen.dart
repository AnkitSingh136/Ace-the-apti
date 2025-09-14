import 'package:ace_the_apti/features/practice/presentation/providers/practice_controller.dart';
import 'package:ace_the_apti/features/practice/presentation/screens/results_screen.dart';
import 'package:ace_the_apti/features/practice/presentation/widgets/question_option_card.dart';
import 'package:ace_the_apti/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// This screen displays a single question during a practice or test series session.
/// It's responsible for showing the question, handling user option selection,
/// and submitting the answer to the [PracticeController].
class QuestionScreen extends HookConsumerWidget {
  const QuestionScreen({super.key});

  static const routeName = '/practice/question';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practiceState = ref.watch(practiceControllerProvider);
    final practiceController = ref.read(practiceControllerProvider.notifier);
    // A local state hook to manage the currently selected radio button option.
    final selectedOption = useState<String?>(null);

    // Listen for the practice session to be marked as 'complete' and navigate
    // to the results screen automatically.
    ref.listen<PracticeState>(practiceControllerProvider, (previous, next) {
      if (next.status == PracticeStatus.complete) {
        context.go(ResultsScreen.routeName);
      }
    });

    // Fallback for unexpected states.
    if (practiceState.status != PracticeStatus.success && practiceState.status != PracticeStatus.complete) {
      return const Scaffold(
        body: Center(child: Text('Loading question...')),
      );
    }

    final question = practiceState.questions[practiceState.currentIndex];
    final progress = (practiceState.currentIndex + 1) / practiceState.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${practiceState.currentIndex + 1}'),
        // A linear progress bar to show the user's progress through the quiz.
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade300,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            // Map the question options to our reusable QuestionOptionCard widget.
            ...question.options.map((option) {
              return QuestionOptionCard(
                title: option,
                groupValue: selectedOption.value ?? '',
                onChanged: (value) {
                  selectedOption.value = value;
                },
                isSelected: selectedOption.value == option,
              );
            }),
            const SizedBox(height: 32),
            CustomPrimaryButton(
              // The button is disabled until an option is selected.
              onPressed: selectedOption.value == null ? null : () {
                practiceController.submitAnswer(question.id, selectedOption.value!);
                // Reset the local selection state for the next question.
                selectedOption.value = null;
              },
              // The button text changes on the last question.
              text: practiceState.currentIndex == practiceState.questions.length - 1
                  ? 'Submit & View Results'
                  : 'Next Question',
            ),
          ],
        ),
      ),
    );
  }
}
