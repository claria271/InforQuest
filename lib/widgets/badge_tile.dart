import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../utils/app_theme.dart';

class BadgeTileWidget extends StatelessWidget {
  final Achievement achievement;
  final bool isEarned;
  final VoidCallback onTap;

  const BadgeTileWidget({
    super.key,
    required this.achievement,
    required this.isEarned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEarned ? AppColors.accent.withOpacity(0.5) : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            width: isEarned ? 2.0 : 1.0,
          ),
          boxShadow: [
            if (isEarned)
              BoxShadow(
                color: AppColors.accent.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isEarned ? AppColors.accent.withOpacity(0.15) : Colors.grey.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isEarned
                  ? Text(achievement.icon, style: const TextStyle(fontSize: 28))
                  : const Icon(Icons.lock_rounded, color: AppColors.locked, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              achievement.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isEarned ? (isDark ? AppColors.textLight : AppColors.textDark) : AppColors.locked,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt_rounded, size: 14, color: AppColors.accent),
                Text(
                  '+${achievement.rewardXp} XP',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.accent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
