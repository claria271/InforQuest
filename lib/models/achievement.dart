class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int rewardXp;
  final int rewardCoins;
  final String condition;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.rewardXp,
    required this.rewardCoins,
    required this.condition,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      rewardXp: json['rewardXp'] as int? ?? 0,
      rewardCoins: json['rewardCoins'] as int? ?? 0,
      condition: json['condition'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'rewardXp': rewardXp,
      'rewardCoins': rewardCoins,
      'condition': condition,
    };
  }
}
