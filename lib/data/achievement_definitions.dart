import '../models/achievement.dart';

class AchievementDefinitions {
  static const List<Achievement> allAchievements = [
    Achievement(
      id: 'first_step',
      title: 'Langkah Pertama',
      description: 'Lulus Level 1 (Pengenalan Informatika)',
      icon: '🥇',
      rewardXp: 30,
      rewardCoins: 0,
      condition: 'pass_level_1',
    ),
    Achievement(
      id: 'comp_thinking',
      title: 'Berpikir Komputasional',
      description: 'Lulus Level 2 (Berpikir Komputasional)',
      icon: '🧠',
      rewardXp: 30,
      rewardCoins: 0,
      condition: 'pass_level_2',
    ),
    Achievement(
      id: 'perfect_score',
      title: 'Sempurna!',
      description: 'Meraih skor 100 pada level mana pun',
      icon: '⭐',
      rewardXp: 50,
      rewardCoins: 0,
      condition: 'score_100',
    ),
    Achievement(
      id: 'streak_3',
      title: 'Konsisten 3',
      description: 'Menjaga streak belajar selama 3 hari berturut-turut',
      icon: '🔥',
      rewardXp: 20,
      rewardCoins: 0,
      condition: 'streak_3',
    ),
    Achievement(
      id: 'streak_7',
      title: 'Konsisten 7',
      description: 'Menjaga streak belajar selama 7 hari berturut-turut',
      icon: '🔥🔥',
      rewardXp: 50,
      rewardCoins: 25,
      condition: 'streak_7',
    ),
    Achievement(
      id: 'bookworm',
      title: 'Kutu Buku',
      description: 'Membaca seluruh bagian materi di minimal 5 level',
      icon: '📚',
      rewardXp: 40,
      rewardCoins: 0,
      condition: 'read_5_levels',
    ),
    Achievement(
      id: 'persistent',
      title: 'Pantang Menyerah',
      description: 'Lulus level setelah sebelumnya gagal minimal 3 kali',
      icon: '💪',
      rewardXp: 30,
      rewardCoins: 0,
      condition: 'pass_after_3_failures',
    ),
    Achievement(
      id: 'master_infoquest',
      title: 'Penakluk Informatika',
      description: 'Lulus Level 10 (Tantangan Akhir Informatika)',
      icon: '🏆',
      rewardXp: 150,
      rewardCoins: 100,
      condition: 'pass_level_10',
    ),
  ];

  static Achievement? getById(String id) {
    try {
      return allAchievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }
}
