import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/storage_service.dart';
import 'settings_provider.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  final StorageService _storage;

  UserNotifier(this._storage) : super(_storage.getUser());

  Future<void> createUser({required String name, required String avatar}) async {
    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      avatar: avatar,
      createdAt: DateTime.now(),
    );
    await _storage.saveUser(newUser);
    state = newUser;
  }

  Future<void> updateUser(UserModel user) async {
    await _storage.saveUser(user);
    state = user;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return UserNotifier(storage);
});
