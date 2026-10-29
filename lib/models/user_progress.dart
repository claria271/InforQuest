class LevelProgress {
  bool unlocked;
  List<String> materialsRead;
  int bestScore;
  int bestCorrect;
  int stars;
  int attempts;
  bool passed;
  bool challengeRewarded;
  int failedAttempts;

  LevelProgress({
    this.unlocked = false,
    List<String>? materialsRead,
    this.bestScore = 0,
    this.bestCorrect = 0,
    this.stars = 0,
    this.attempts = 0,
    this.passed = false,
    this.challengeRewarded = false,
    this.failedAttempts = 0,
  }) : materialsRead = materialsRead ?? [];

  factory LevelProgress.fromJson(Map<String, dynamic> json) {
    return LevelProgress(
      unlocked: json['unlocked'] as bool? ?? false,
      materialsRead: (json['materialsRead'] as List?)?.map((e) => e.toString()).toList() ?? [],
      bestScore: json['bestScore'] as int? ?? 0,
      bestCorrect: json['bestCorrect'] as int? ?? 0,
      stars: json['stars'] as int? ?? 0,
      attempts: json['attempts'] as int? ?? 0,
      passed: json['passed'] as bool? ?? false,
      challengeRewarded: json['challengeRewarded'] as bool? ?? false,
      failedAttempts: json['failedAttempts'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'unlocked': unlocked,
      'materialsRead': materialsRead,
      'bestScore': bestScore,
      'bestCorrect': bestCorrect,
      'stars': stars,
      'attempts': attempts,
      'passed': passed,
      'challengeRewarded': challengeRewarded,
      'failedAttempts': failedAttempts,
    };
  }

  LevelProgress copyWith({
    bool? unlocked,
    List<String>? materialsRead,
    int? bestScore,
    int? bestCorrect,
    int? stars,
    int? attempts,
    bool? passed,
    bool? challengeRewarded,
    int? failedAttempts,
  }) {
    return LevelProgress(
      unlocked: unlocked ?? this.unlocked,
      materialsRead: materialsRead ?? List.from(this.materialsRead),
      bestScore: bestScore ?? this.bestScore,
      bestCorrect: bestCorrect ?? this.bestCorrect,
      stars: stars ?? this.stars,
      attempts: attempts ?? this.attempts,
      passed: passed ?? this.passed,
      challengeRewarded: challengeRewarded ?? this.challengeRewarded,
      failedAttempts: failedAttempts ?? this.failedAttempts,
    );
  }
}

class UserProgress {
  String userId;
  int totalXp;
  int coins;
  int streak;
  int longestStreak;
  String lastActiveDate; // yyyy-MM-dd
  Map<int, LevelProgress> levels;
  List<String> earnedAchievements;

  UserProgress({
    required this.userId,
    this.totalXp = 0,
    this.coins = 0,
    this.streak = 0,
    this.longestStreak = 0,
    this.lastActiveDate = '',
    Map<int, LevelProgress>? levels,
    List<String>? earnedAchievements,
  })  : levels = levels ?? {1: LevelProgress(unlocked: true)},
        earnedAchievements = earnedAchievements ?? [];

  factory UserProgress.initial(String userId) {
    return UserProgress(
      userId: userId,
      totalXp: 0,
      coins: 0,
      streak: 0,
      longestStreak: 0,
      lastActiveDate: '',
      levels: {
        1: LevelProgress(unlocked: true),
        2: LevelProgress(unlocked: false),
        3: LevelProgress(unlocked: false),
        4: LevelProgress(unlocked: false),
        5: LevelProgress(unlocked: false),
        6: LevelProgress(unlocked: false),
        7: LevelProgress(unlocked: false),
        8: LevelProgress(unlocked: false),
        9: LevelProgress(unlocked: false),
        10: LevelProgress(unlocked: false),
      },
      earnedAchievements: [],
    );
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final rawLevels = json['levels'] as Map<String, dynamic>? ?? {};
    final parsedLevels = <int, LevelProgress>{};
    rawLevels.forEach((key, val) {
      final lvlId = int.tryParse(key);
      if (lvlId != null) {
        parsedLevels[lvlId] = LevelProgress.fromJson(Map<String, dynamic>.from(val as Map));
      }
    });

    // Make sure level 1 is always unlocked
    if (!parsedLevels.containsKey(1)) {
      parsedLevels[1] = LevelProgress(unlocked: true);
    } else {
      parsedLevels[1]!.unlocked = true;
    }

    // Ensure all 10 levels exist in map
    for (int i = 1; i <= 10; i++) {
      parsedLevels.putIfAbsent(i, () => LevelProgress(unlocked: i == 1));
    }

    return UserProgress(
      userId: json['userId'] as String? ?? 'default_user',
      totalXp: json['totalXp'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] as String? ?? '',
      levels: parsedLevels,
      earnedAchievements: (json['earnedAchievements'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final serializedLevels = <String, dynamic>{};
    levels.forEach((key, val) {
      serializedLevels[key.toString()] = val.toJson();
    });

    return {
      'userId': userId,
      'totalXp': totalXp,
      'coins': coins,
      'streak': streak,
      'longestStreak': longestStreak,
      'lastActiveDate': lastActiveDate,
      'levels': serializedLevels,
      'earnedAchievements': earnedAchievements,
    };
  }
}
