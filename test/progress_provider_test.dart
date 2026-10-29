import 'package:flutter_test/flutter_test.dart';
import 'package:infoquest/models/user_progress.dart';
import 'package:infoquest/services/achievement_service.dart';

void main() {
  group('UserProgress & Achievement Tests', () {
    test('UserProgress JSON serialization and deserialization retains data', () {
      final initial = UserProgress.initial('u_123');
      initial.totalXp = 450;
      initial.coins = 120;
      initial.streak = 5;
      initial.earnedAchievements.add('first_step');
      initial.levels[1]!.passed = true;
      initial.levels[1]!.bestScore = 100;
      initial.levels[1]!.stars = 3;

      final json = initial.toJson();
      final restored = UserProgress.fromJson(json);

      expect(restored.userId, 'u_123');
      expect(restored.totalXp, 450);
      expect(restored.coins, 120);
      expect(restored.streak, 5);
      expect(restored.earnedAchievements, contains('first_step'));
      expect(restored.levels[1]!.passed, isTrue);
      expect(restored.levels[1]!.bestScore, 100);
      expect(restored.levels[1]!.stars, 3);
    });

    test('Achievement evaluation unlocks first_step when Level 1 is passed', () {
      final progress = UserProgress.initial('u_123');
      progress.levels[1]!.passed = true;

      final newlyEarned = AchievementService.evaluate(progress);
      expect(newlyEarned, contains('first_step'));
      expect(progress.earnedAchievements, contains('first_step'));
    });

    test('Achievement evaluation unlocks persistent when passed after >=3 failures', () {
      final progress = UserProgress.initial('u_123');
      progress.levels[2]!.passed = true;
      progress.levels[2]!.failedAttempts = 3;

      final newlyEarned = AchievementService.evaluate(progress);
      expect(newlyEarned, contains('persistent'));
    });
  });
}
