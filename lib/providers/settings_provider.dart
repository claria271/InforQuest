import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

class SettingsState {
  final bool isDarkMode;
  final bool isSoundEnabled;
  final bool isVibrationEnabled;
  final bool hasCompletedOnboarding;

  const SettingsState({
    required this.isDarkMode,
    required this.isSoundEnabled,
    required this.isVibrationEnabled,
    required this.hasCompletedOnboarding,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? isSoundEnabled,
    bool? isVibrationEnabled,
    bool? hasCompletedOnboarding,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final StorageService _storage;

  SettingsNotifier(this._storage)
      : super(SettingsState(
          isDarkMode: _storage.isDarkMode(),
          isSoundEnabled: _storage.isSoundEnabled(),
          isVibrationEnabled: _storage.isVibrationEnabled(),
          hasCompletedOnboarding: _storage.hasCompletedOnboarding(),
        ));

  Future<void> toggleDarkMode(bool value) async {
    await _storage.setDarkMode(value);
    state = state.copyWith(isDarkMode: value);
  }

  Future<void> toggleSound(bool value) async {
    await _storage.setSoundEnabled(value);
    state = state.copyWith(isSoundEnabled: value);
  }

  Future<void> toggleVibration(bool value) async {
    await _storage.setVibrationEnabled(value);
    state = state.copyWith(isVibrationEnabled: value);
  }

  Future<void> completeOnboarding() async {
    await _storage.setCompletedOnboarding(true);
    state = state.copyWith(hasCompletedOnboarding: true);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in ProviderScope');
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return SettingsNotifier(storage);
});
