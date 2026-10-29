import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class StreakChip extends StatelessWidget {
  final int streak;

  const StreakChip({
    super.key,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    final hasStreak = streak > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: hasStreak ? AppColors.accent.withOpacity(0.15) : Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasStreak ? AppColors.accent.withOpacity(0.4) : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hasStreak ? '🔥' : '💤',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 6),
          Text(
            '$streak Hari',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: hasStreak ? const Color(0xFFD97706) : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
