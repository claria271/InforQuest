import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/level.dart';
import '../models/quiz_result.dart';
import '../models/user_progress.dart';
import '../services/content_service.dart';
import '../services/game_engine.dart';
import '../services/storage_service.dart';
import 'settings_provider.dart';

final contentServiceProvider = Provider<ContentService>((ref) {
  return ContentService();
});

final levelsProvider = FutureProvider<List<LevelModel>>((ref) async {
  final service = ref.watch(contentServiceProvider);
  return await service.getLevels();
});

class ProgressNotifier extends StateNotifier<UserProgress> {
  final StorageService _storage;

  ProgressNotifier(this._storage, String userId)
      : super(_storage.getProgress() ?? UserProgress.initial(userId));

  Future<QuizResult> recordQuizOutcome({
    required LevelModel level,
    required int correctCount,
    required int totalCount,
    required int livesLeft,
    required Map<int, int> totalMaterialsPerLevel,
    DateTime? testTime,
  }) async {
    final result = GameEngine.finishQuiz(
      progress: state,
      level: level,
      correctCount: correctCount,
      totalCount: totalCount,
      livesLeft: livesLeft,
      totalMaterialsPerLevel: totalMaterialsPerLevel,
      testTime: testTime,
    );

    // Save to storage
    await _storage.saveProgress(state);
    await _storage.saveQuizResult(result);

    // Trigger state change
    state = UserProgress.fromJson(state.toJson());
    return result;
  }

  Future<void> markSectionRead({
    required int levelId,
    required String sectionId,
    required Map<int, int> totalMaterialsPerLevel,
  }) async {
    final modified = GameEngine.markMaterialRead(
      progress: state,
      levelId: levelId,
      sectionId: sectionId,
      totalMaterialsPerLevel: totalMaterialsPerLevel,
    );
    if (modified) {
      await _storage.saveProgress(state);
      state = UserProgress.fromJson(state.toJson());
    }
  }

  Future<int> completeChallenge({
    required int levelId,
    required Map<int, int> totalMaterialsPerLevel,
  }) async {
    final bonus = GameEngine.completeChallenge(
      progress: state,
      levelId: levelId,
      totalMaterialsPerLevel: totalMaterialsPerLevel,
    );
    if (bonus > 0) {
      await _storage.saveProgress(state);
      state = UserProgress.fromJson(state.toJson());
    }
    return bonus;
  }

  Future<void> resetProgress() async {
    await _storage.resetAllProgress(state.userId);
    final fresh = UserProgress.initial(state.userId);
    await _storage.saveProgress(fresh);
    state = fresh;
  }
}

final progressProvider = StateNotifierProvider<ProgressNotifier, UserProgress>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final user = storage.getUser();
  final userId = user?.id ?? 'default_user';
  return ProgressNotifier(storage, userId);
});

final quizHistoryProvider = Provider<List<QuizResult>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  // Re-read history whenever progress changes
  ref.watch(progressProvider);
  return storage.getQuizHistory();
});
