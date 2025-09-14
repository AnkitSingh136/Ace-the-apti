import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Provider for the StorageRepository
final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(FirebaseStorage.instance);
});

class StorageRepository {
  final FirebaseStorage _storage;

  StorageRepository(this._storage);

  // Method to upload an avatar image and get the download URL
  Future<String> uploadAvatar({
    required XFile image,
    required String uid,
  }) async {
    try {
      final file = File(image.path);
      final ref = _storage.ref().child('avatars').child(uid);
      final uploadTask = await ref.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      throw Exception('Failed to upload avatar: ${e.message}');
    }
  }
}
