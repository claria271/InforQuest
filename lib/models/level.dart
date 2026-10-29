class LevelModel {
  final int id;
  final String title;
  final String objective;
  final int questionCount;
  final int passScore;
  final int rewardXp;
  final int rewardCoins;
  final String difficulty;
  final String? challengeType;
  final String? challengeTitle;

  const LevelModel({
    required this.id,
    required this.title,
    required this.objective,
    required this.questionCount,
    required this.passScore,
    required this.rewardXp,
    required this.rewardCoins,
    required this.difficulty,
    this.challengeType,
    this.challengeTitle,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] as int,
      title: json['title'] as String,
      objective: json['objective'] as String,
      questionCount: json['questionCount'] as int? ?? 10,
      passScore: json['passScore'] as int? ?? 80,
      rewardXp: json['rewardXp'] as int? ?? 50,
      rewardCoins: json['rewardCoins'] as int? ?? 25,
      difficulty: json['difficulty'] as String? ?? 'mudah',
      challengeType: json['challengeType'] as String?,
      challengeTitle: json['challengeTitle'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'objective': objective,
      'questionCount': questionCount,
      'passScore': passScore,
      'rewardXp': rewardXp,
      'rewardCoins': rewardCoins,
      'difficulty': difficulty,
      'challengeType': challengeType,
      'challengeTitle': challengeTitle,
    };
  }
}
