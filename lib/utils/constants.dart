class AppConstants {
  static const int passScore = 80;
  static const int livesPerAttempt = 3;
  static const int xpPerCorrect = 10;
  static const int coinPerCorrect = 5;
  static const int perfectBonusXp = 30;
  static const int challengeBonusXp = 20;
  static const int streakBonusPerDay = 5;

  static const String appName = 'InfoQuest';
  static const String appTagline = 'Petualangan Informatika';

  // Avatar presets
  static const List<String> avatars = [
    '🦊', // Rubah Cerdik
    '🦉', // Burung Hantu Bijak
    '🤖', // Robot Futuristik
    '🧙‍♂️', // Penyihir Kode
    '🚀', // Penjelajah Angkasa
    '🐱‍💻', // Kucing Hacker
    '🦁', // Singa Berani
    '⚡', // Kilat Cepat
  ];

  // Rank definitions based on XP
  static String getRankName(int xp) {
    if (xp >= 1800) return 'Master Informatika';
    if (xp >= 1200) return 'Programmer Muda';
    if (xp >= 700) return 'Pemecah Masalah';
    if (xp >= 300) return 'Penjelajah';
    return 'Pemula Digital';
  }

  static double getRankProgress(int xp) {
    if (xp >= 1800) return 1.0;
    if (xp >= 1200) return (xp - 1200) / (1800 - 1200);
    if (xp >= 700) return (xp - 700) / (1200 - 700);
    if (xp >= 300) return (xp - 300) / (700 - 300);
    return xp / 300.0;
  }
}
