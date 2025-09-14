import 'package:ace_the_apti/features/auth/data/repositories/user_repository.dart';
import 'package:ace_the_apti/features/auth/presentation/providers/auth_controller.dart';
import 'package:ace_the_apti/features/profile/presentation/providers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref, String currentName) {
    final nameController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Full Name'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  ref.read(profileControllerProvider.notifier).updateUserName(
                    newName: nameController.text.trim(),
                    onError: (error) => _showErrorSnackbar(context, error),
                  );
                  // Invalidate user provider to refetch data
                  ref.invalidate(userProvider);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickAndUploadAvatar(WidgetRef ref, BuildContext context) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await ref.read(profileControllerProvider.notifier).updateUserAvatar(
        image: image,
        onError: (error) => _showErrorSnackbar(context, error),
      );
      // Invalidate user provider to refetch data
      ref.invalidate(userProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider);
    final isLoading = ref.watch(profileControllerProvider);
    final isAuthControllerLoading = ref.watch(authControllerProvider);

    return Scaffold(
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not found.'));
          }
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _pickAndUploadAvatar(ref, context),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                        child: user.avatarUrl == null ? const Icon(Icons.person, size: 60) : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user.name, style: Theme.of(context).textTheme.titleLarge),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditNameDialog(context, ref, user.name),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(user.email),
                    ),
                    const Divider(),
                    ListTile(
                      leading: Icon(Icons.monetization_on, color: Colors.amber.shade400),
                      title: const Text('Coins'),
                      trailing: Text(
                        user.coins.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: isAuthControllerLoading ? null : () => ref.read(authControllerProvider.notifier).signOut(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: ${err.toString()}')),
      ),
    );
  }
}
