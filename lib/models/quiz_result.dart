class QuizResult {
  final String id;
  final int levelId;
  final int correctCount;
  final int totalCount;
  final int score;
  final int livesLeft;
  final bool passed;
  final int xpEarned;
  final int coinsEarned;
  final DateTime takenAt;
  final List<String> newBadges;

  const QuizResult({
    required this.id,
    required this.levelId,
    required this.correctCount,
    required this.totalCount,
    required this.score,
    required this.livesLeft,
    required this.passed,
    required this.xpEarned,
    required this.coinsEarned,
    required this.takenAt,
    this.newBadges = const [],
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      id: json['id'] as String,
      levelId: json['levelId'] as int,
      correctCount: json['correctCount'] as int,
      totalCount: json['totalCount'] as int,
      score: json['score'] as int,
      livesLeft: json['livesLeft'] as int,
      passed: json['passed'] as bool,
      xpEarned: json['xpEarned'] as int,
      coinsEarned: json['coinsEarned'] as int,
      takenAt: DateTime.parse(json['takenAt'] as String),
      newBadges: (json['newBadges'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'levelId': levelId,
      'correctCount': correctCount,
      'totalCount': totalCount,
      'score': score,
      'livesLeft': livesLeft,
      'passed': passed,
      'xpEarned': xpEarned,
      'coinsEarned': coinsEarned,
      'takenAt': takenAt.toIso8601String(),
      'newBadges': newBadges,
    };
  }
}
