import 'package:flutter_test/flutter_test.dart';
import 'package:infoquest/models/level.dart';
import 'package:infoquest/models/user_progress.dart';
import 'package:infoquest/services/game_engine.dart';

void main() {
  group('GameEngine Logic Tests (T03 - T14)', () {
    late LevelModel level1;
    late Map<int, int> totalMaterials;

    setUp(() {
      level1 = const LevelModel(
        id: 1,
        title: 'Pengenalan Informatika',
        objective: 'Test objective 1',
        questionCount: 10,
        passScore: 80,
        rewardXp: 50,
        rewardCoins: 25,
        difficulty: 'mudah',
      );

      totalMaterials = {1: 3, 2: 4};
    });

    test('T03: Level 2 remains locked if Level 1 is not passed', () {
      final progress = UserProgress.initial('user_1');
      expect(GameEngine.canUnlock(progress, 2, totalMaterials[1]!), isFalse);
    });

    test('T04: Level 2 remains locked if Level 1 passed but materials not completely read', () {
      final progress = UserProgress.initial('user_1');
      progress.levels[1]!.passed = true;
      progress.levels[1]!.bestScore = 90;
      progress.levels[1]!.materialsRead = ['l1_m1']; // only 1 of 3 read

      expect(GameEngine.canUnlock(progress, 2, totalMaterials[1]!), isFalse);
    });

    test('T05: 8 correct out of 10 results in score 80 and PASS', () {
      final progress = UserProgress.initial('user_1');
      final result = GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 8,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
      );

      expect(result.score, 80);
      expect(result.passed, isTrue);
      expect(progress.levels[1]!.passed, isTrue);
      expect(progress.levels[1]!.stars, 1);
    });

    test('T06: 7 correct out of 10 results in score 70 and FAIL', () {
      final progress = UserProgress.initial('user_1');
      final result = GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 7,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
      );

      expect(result.score, 70);
      expect(result.passed, isFalse);
      expect(progress.levels[1]!.passed, isFalse);
      expect(progress.levels[1]!.stars, 0);
      expect(progress.levels[1]!.failedAttempts, 1);
    });

    test('T07: 3 wrong answers ends lives (livesLeft = 0)', () {
      final progress = UserProgress.initial('user_1');
      final result = GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 4,
        totalCount: 10,
        livesLeft: 0, // exhausted lives
        totalMaterialsPerLevel: totalMaterials,
      );

      expect(result.livesLeft, 0);
      expect(result.passed, isFalse);
    });

    test('T08: First time 8 correct earns XP = 8*10 + first pass reward + streak bonus', () {
      final progress = UserProgress.initial('user_1');
      final testDate = DateTime(2026, 10, 26);

      final result = GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 8,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
        testTime: testDate,
      );

      // 8 * 10 = 80 XP for correct
      // + 50 XP for first pass
      // + 5 * 1 = 5 XP for streak
      expect(result.xpEarned, 80 + 50 + 5);
      // 8 * 5 = 40 + 25 = 65 coins
      expect(result.coinsEarned, 40 + 25);
    });

    test('T09: Retrying with same score (8 correct) yields 0 additional XP/Coins (Anti-Farming)', () {
      final progress = UserProgress.initial('user_1');
      final testDate = DateTime(2026, 10, 26);

      // First attempt
      GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 8,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
        testTime: testDate,
      );

      final xpAfterFirst = progress.totalXp;
      final coinsAfterFirst = progress.coins;

      // Second attempt on same day with same score 8
      final secondResult = GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 8,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
        testTime: testDate,
      );

      expect(secondResult.xpEarned, 0);
      expect(secondResult.coinsEarned, 0);
      expect(progress.totalXp, xpAfterFirst);
      expect(progress.coins, coinsAfterFirst);
    });

    test('T10: Improving score from 8 to 10 correct gives (2*10) + perfect bonus (30)', () {
      final progress = UserProgress.initial('user_1');
      final testDate = DateTime(2026, 10, 26);

      // Attempt 1: 8 correct
      GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 8,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
        testTime: testDate,
      );

      // Attempt 2: 10 correct (Perfect 100)
      final improvedResult = GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 10,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
        testTime: testDate,
      );

      // newCorrect = 10 - 8 = 2 -> 20 XP
      // perfect bonus = 30 XP
      // streak bonus = 0 (already active today)
      expect(improvedResult.xpEarned, 20 + 30);
      // new coins = 2 * 5 = 10
      expect(improvedResult.coinsEarned, 10);
      expect(progress.levels[1]!.stars, 3);
    });

    test('T13: Pass + all materials complete unlocks Level 2', () {
      final progress = UserProgress.initial('user_1');
      // Read all 3 sections of level 1
      GameEngine.markMaterialRead(
        progress: progress,
        levelId: 1,
        sectionId: 'l1_m1',
        totalMaterialsPerLevel: totalMaterials,
      );
      GameEngine.markMaterialRead(
        progress: progress,
        levelId: 1,
        sectionId: 'l1_m2',
        totalMaterialsPerLevel: totalMaterials,
      );
      GameEngine.markMaterialRead(
        progress: progress,
        levelId: 1,
        sectionId: 'l1_m3',
        totalMaterialsPerLevel: totalMaterials,
      );

      // Pass quiz
      GameEngine.finishQuiz(
        progress: progress,
        level: level1,
        correctCount: 9,
        totalCount: 10,
        livesLeft: 3,
        totalMaterialsPerLevel: totalMaterials,
      );

      expect(progress.levels[2]!.unlocked, isTrue);
    });

    test('T14: Consecutive daily streak increments, skipping day resets to 1', () {
      final progress = UserProgress.initial('user_1');

      // Day 1
      GameEngine.updateDailyStreak(progress, DateTime(2026, 10, 20));
      expect(progress.streak, 1);

      // Day 2 (consecutive)
      GameEngine.updateDailyStreak(progress, DateTime(2026, 10, 21));
      expect(progress.streak, 2);

      // Day 4 (skipped day 3)
      GameEngine.updateDailyStreak(progress, DateTime(2026, 10, 23));
      expect(progress.streak, 1);
      expect(progress.longestStreak, 2);
    });
  });
}
