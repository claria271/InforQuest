import '../models/user_progress.dart';
import '../data/achievement_definitions.dart';

class AchievementService {
  // Evaluates which achievements are unlocked and returns newly unlocked achievement IDs.
  static List<String> evaluate(UserProgress progress, {Map<int, int>? totalMaterialsPerLevel}) {
    final newlyEarned = <String>[];

    void checkAndAdd(String badgeId, bool conditionMet) {
      if (conditionMet && !progress.earnedAchievements.contains(badgeId)) {
        progress.earnedAchievements.add(badgeId);
        newlyEarned.add(badgeId);
        // Add achievement reward to user progress
        final badge = AchievementDefinitions.getById(badgeId);
        if (badge != null) {
          progress.totalXp += badge.rewardXp;
          progress.coins += badge.rewardCoins;
        }
      }
    }

    // 1. Langkah Pertama (Lulus Level 1)
    final lvl1 = progress.levels[1];
    checkAndAdd('first_step', lvl1 != null && lvl1.passed);

    // 2. Berpikir Komputasional (Lulus Level 2)
    final lvl2 = progress.levels[2];
    checkAndAdd('comp_thinking', lvl2 != null && lvl2.passed);

    // 3. Sempurna! (Skor 100 pada level mana pun)
    final hasScore100 = progress.levels.values.any((lvl) => lvl.bestScore == 100);
    checkAndAdd('perfect_score', hasScore100);

    // 4. Konsisten 3 (Streak 3)
    checkAndAdd('streak_3', progress.streak >= 3 || progress.longestStreak >= 3);

    // 5. Konsisten 7 (Streak 7)
    checkAndAdd('streak_7', progress.streak >= 7 || progress.longestStreak >= 7);

    // 6. Kutu Buku (Membaca seluruh materi di minimal 5 level)
    int fullyReadLevelsCount = 0;
    progress.levels.forEach((lvlId, lp) {
      final totalSections = totalMaterialsPerLevel?[lvlId] ?? 4; // default estimate if not provided
      if (lp.materialsRead.length >= totalSections) {
        fullyReadLevelsCount++;
      }
    });
    checkAndAdd('bookworm', fullyReadLevelsCount >= 5);

    // 7. Pantang Menyerah (Lulus level setelah gagal >= 3 kali)
    final hasPersistentPass = progress.levels.values.any((lvl) => lvl.passed && lvl.failedAttempts >= 3);
    checkAndAdd('persistent', hasPersistentPass);

    // 8. Penakluk Informatika (Lulus Level 10)
    final lvl10 = progress.levels[10];
    checkAndAdd('master_infoquest', lvl10 != null && lvl10.passed);

    return newlyEarned;
  }
}
