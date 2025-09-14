import 'package:ace_the_apti/features/practice/presentation/screens/practice_screen.dart';
import 'package:ace_the_apti/features/profile/presentation/screens/profile_screen.dart';
import 'package:ace_the_apti/features/test_series/presentation/screens/test_series_screen.dart';
import 'package:ace_the_apti/widgets/coin_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// HomeScreen is the main shell of the application after a user logs in.
/// It contains the BottomNavigationBar to switch between the main features
/// of the app: Practice, Test Series, and Profile.
class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // A state hook to keep track of the selected tab index.
    final selectedIndex = useState(0);

    // The list of screens that correspond to the BottomNavigationBar items.
    final List<Widget> screens = [
      const PracticeScreen(),
      const TestSeriesScreen(),
      const ProfileScreen(),
    ];

    // The list of titles for the AppBar, corresponding to each screen.
    final List<String> titles = [
      'Practice',
      'Test Series',
      'Profile',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[selectedIndex.value]),
        actions: const [
          // The reusable coin counter widget.
          CoinCounter(),
        ],
      ),
      // IndexedStack is used to preserve the state of each screen when switching tabs.
      body: IndexedStack(
        index: selectedIndex.value,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (index) {
          // Update the state to switch the visible screen.
          selectedIndex.value = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard_outlined),
            activeIcon: Icon(Icons.leaderboard),
            label: 'Test Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
