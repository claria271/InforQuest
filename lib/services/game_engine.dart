import 'dart:math';
import '../models/level.dart';
import '../models/user_progress.dart';
import '../models/quiz_result.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'achievement_service.dart';

class GameEngine {
  /// Evaluates whether level [levelId] can be unlocked based on progress.
  static bool canUnlock(UserProgress progress, int levelId, int totalSectionsInPrevLevel) {
    if (levelId <= 1) return true;
    final prevLp = progress.levels[levelId - 1];
    if (prevLp == null) return false;
    final allRead = prevLp.materialsRead.length >= totalSectionsInPrevLevel;
    return prevLp.passed && allRead;
  }

  /// Updates user daily streak and returns the bonus XP awarded.
  static int updateDailyStreak(UserProgress progress, DateTime now) {
    final todayStr = AppHelpers.formatDate(now);
    if (progress.lastActiveDate == todayStr) {
      // Already active today; no new streak bonus
      return 0;
    }

    if (progress.lastActiveDate.isNotEmpty) {
      final parts = progress.lastActiveDate.split('-');
      if (parts.length == 3) {
        final lastDate = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        final differenceInDays = DateTime(now.year, now.month, now.day)
            .difference(lastDate)
            .inDays;

        if (differenceInDays == 1) {
          // Consecutive day
          progress.streak += 1;
        } else if (differenceInDays > 1) {
          // Missed at least one whole day -> reset streak to 1
          progress.streak = 1;
        }
      } else {
        progress.streak = 1;
      }
    } else {
      progress.streak = 1;
    }

    progress.longestStreak = max(progress.longestStreak, progress.streak);
    progress.lastActiveDate = todayStr;

    final bonus = (AppConstants.streakBonusPerDay * min(progress.streak, 7)).toInt();
    return bonus;
  }

  /// Evaluates and unlocks subsequent levels if conditions are met.
  static void checkAndUnlockLevels(UserProgress progress, Map<int, int> totalMaterialsPerLevel) {
    for (int lvlId = 2; lvlId <= 10; lvlId++) {
      final prevCount = totalMaterialsPerLevel[lvlId - 1] ?? 4;
      if (canUnlock(progress, lvlId, prevCount)) {
        final currentLp = progress.levels.putIfAbsent(lvlId, () => LevelProgress());
        currentLp.unlocked = true;
      }
    }
  }

  /// Main logic for finishing a quiz attempt.
  static QuizResult finishQuiz({
    required UserProgress progress,
    required LevelModel level,
    required int correctCount,
    required int totalCount,
    required int livesLeft,
    required Map<int, int> totalMaterialsPerLevel,
    DateTime? testTime,
  }) {
    final now = testTime ?? DateTime.now();
    final score = totalCount > 0 ? ((correctCount / totalCount) * 100).round() : 0;
    final passed = score >= level.passScore;

    final lp = progress.levels.putIfAbsent(level.id, () => LevelProgress(unlocked: level.id == 1));

    // 1. XP & Coins only for score improvement (anti-farming)
    final newCorrect = max(0, correctCount - lp.bestCorrect);
    var xpEarned = newCorrect * AppConstants.xpPerCorrect;
    var coinsEarned = newCorrect * AppConstants.coinPerCorrect;

    // 2. First-time pass reward
    if (passed && !lp.passed) {
      xpEarned += level.rewardXp;
      coinsEarned += level.rewardCoins;
    }

    // 3. Perfect score bonus (once per level)
    if (score == 100 && lp.bestScore < 100) {
      xpEarned += AppConstants.perfectBonusXp;
    }

    // 4. Daily streak bonus
    final streakXp = updateDailyStreak(progress, now);
    xpEarned += streakXp;

    // 5. Update best records & stars
    lp.attempts += 1;
    if (!passed) {
      lp.failedAttempts += 1;
    }
    lp.bestCorrect = max(lp.bestCorrect, correctCount);
    lp.bestScore = max(lp.bestScore, score);
    lp.stars = AppHelpers.calculateStars(lp.bestScore);
    lp.passed = lp.passed || passed;

    // 6. Check and unlock next level
    checkAndUnlockLevels(progress, totalMaterialsPerLevel);

    // 7. Update progress totals
    progress.totalXp += xpEarned;
    progress.coins += coinsEarned;

    // 8. Evaluate achievements
    final newBadges = AchievementService.evaluate(
      progress,
      totalMaterialsPerLevel: totalMaterialsPerLevel,
    );

    return QuizResult(
      id: 'quiz_${level.id}_${now.millisecondsSinceEpoch}',
      levelId: level.id,
      correctCount: correctCount,
      totalCount: totalCount,
      score: score,
      livesLeft: livesLeft,
      passed: passed,
      xpEarned: xpEarned,
      coinsEarned: coinsEarned,
      takenAt: now,
      newBadges: newBadges,
    );
  }

  /// Marks a material section as read and unlocks next level if conditions now met.
  static bool markMaterialRead({
    required UserProgress progress,
    required int levelId,
    required String sectionId,
    required Map<int, int> totalMaterialsPerLevel,
  }) {
    final lp = progress.levels.putIfAbsent(levelId, () => LevelProgress(unlocked: levelId == 1));
    if (!lp.materialsRead.contains(sectionId)) {
      lp.materialsRead.add(sectionId);
      // Check if this action triggers unlocking next level
      checkAndUnlockLevels(progress, totalMaterialsPerLevel);
      // Check for bookworm achievement
      AchievementService.evaluate(progress, totalMaterialsPerLevel: totalMaterialsPerLevel);
      return true;
    }
    return false;
  }

  /// Completes an interactive mini-game challenge.
  static int completeChallenge({
    required UserProgress progress,
    required int levelId,
    required Map<int, int> totalMaterialsPerLevel,
  }) {
    final lp = progress.levels.putIfAbsent(levelId, () => LevelProgress(unlocked: levelId == 1));
    if (!lp.challengeRewarded) {
      lp.challengeRewarded = true;
      progress.totalXp += AppConstants.challengeBonusXp;
      AchievementService.evaluate(progress, totalMaterialsPerLevel: totalMaterialsPerLevel);
      return AppConstants.challengeBonusXp;
    }
    return 0;
  }
}
