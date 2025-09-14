import 'package:ace_the_apti/features/auth/data/repositories/auth_repository.dart';
import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:ace_the_apti/features/profile/data/repositories/storage_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Provider for the ProfileController
final profileControllerProvider =
    StateNotifierProvider<ProfileController, bool>((ref) {
  return ProfileController(
    ref.watch(userRepositoryProvider),
    ref.watch(storageRepositoryProvider),
    ref.watch(authRepositoryProvider),
  );
});

class ProfileController extends StateNotifier<bool> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final AuthRepository _authRepository;

  ProfileController(
    this._userRepository,
    this._storageRepository,
    this._authRepository,
  ) : super(false);

  Future<void> updateUserName({
    required String newName,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final uid = _authRepository.currentUser!.uid;
      await _userRepository.updateUser(uid, {'name': newName});
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }

  Future<void> updateUserAvatar({
    required XFile image,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final uid = _authRepository.currentUser!.uid;
      final avatarUrl = await _storageRepository.uploadAvatar(image: image, uid: uid);
      await _userRepository.updateUser(uid, {'avatarUrl': avatarUrl});
    } catch (e) {
      onError(e.toString());
    } finally {
      state = false;
    }
  }
}
