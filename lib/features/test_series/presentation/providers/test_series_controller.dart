import 'package:ace_the_apti/features/auth/data/repositories/auth_repository.dart';
import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:ace_the_apti/features/auth/domain/user_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for the TestSeriesController
final testSeriesControllerProvider =
    StateNotifierProvider<TestSeriesController, bool>((ref) {
  return TestSeriesController(
    ref.watch(userRepositoryProvider),
    ref.watch(authRepositoryProvider),
    ref.watch(userProvider),
  );
});

class TestSeriesController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final AuthRepository _authRepository;
  final AsyncValue<UserModel?> _user;

  TestSeriesController(this._userRepository, this._authRepository, this._user)
      : super(false);

  static const int unlockCost = 500;

  Future<void> unlockTestSeries({required Function(String) onError}) async {
    state = true;
    try {
      final uid = _authRepository.currentUser!.uid;
      final user = _user.asData?.value;

      if (user == null) {
        throw Exception("User not found.");
      }
      if (user.coins < unlockCost) {
        throw Exception("Not enough coins to unlock.");
      }

      final newCoinBalance = user.coins - unlockCost;
      await _userRepository.updateUser(uid, {
        'coins': newCoinBalance,
        'hasUnlockedTestSeries': true,
      });

    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}
