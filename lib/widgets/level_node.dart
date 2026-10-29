import 'package:flutter/material.dart';
import '../models/level.dart';
import '../models/user_progress.dart';
import '../utils/app_theme.dart';

class LevelNodeWidget extends StatelessWidget {
  final LevelModel level;
  final LevelProgress? progress;
  final bool isNextActive;
  final VoidCallback onTap;

  const LevelNodeWidget({
    super.key,
    required this.level,
    required this.progress,
    required this.isNextActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = progress?.unlocked ?? (level.id == 1);
    final isPassed = progress?.passed ?? false;
    final stars = progress?.stars ?? 0;
    final bestScore = progress?.bestScore ?? 0;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color nodeColor;
    Widget centerIcon;

    if (!isUnlocked) {
      nodeColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
      centerIcon = const Icon(Icons.lock_rounded, color: AppColors.locked, size: 28);
    } else if (isPassed) {
      nodeColor = AppColors.correct;
      centerIcon = const Icon(Icons.check_rounded, color: Colors.white, size: 30);
    } else {
      // Unlocked, not yet passed
      nodeColor = AppColors.primary;
      centerIcon = const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 34);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isNextActive
                  ? AppColors.primary
                  : (isUnlocked
                      ? (isPassed ? AppColors.correct.withOpacity(0.4) : AppColors.primary.withOpacity(0.3))
                      : Colors.transparent),
              width: isNextActive ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isNextActive
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Circle Node
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: nodeColor,
                      shape: BoxShape.circle,
                      boxShadow: isUnlocked
                          ? [
                              BoxShadow(
                                color: nodeColor.withOpacity(0.35),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(child: centerIcon),
                  ),
                  if (isNextActive)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, size: 12, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isUnlocked
                                ? AppColors.primary.withOpacity(0.12)
                                : Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Level ${level.id}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isUnlocked ? AppColors.primary : AppColors.locked,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          level.difficulty.toUpperCase(),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: level.difficulty == 'mudah'
                                ? AppColors.correct
                                : (level.difficulty == 'sedang' ? AppColors.accent : AppColors.wrong),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      level.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isUnlocked
                                ? (isDark ? AppColors.textLight : AppColors.textDark)
                                : AppColors.locked,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Stars or Lock requirement
                    if (!isUnlocked)
                      Row(
                        children: [
                          const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.locked),
                          const SizedBox(width: 4),
                          Text(
                            'Terkunci (Lulus Level ${level.id - 1})',
                            style: const TextStyle(fontSize: 12, color: AppColors.locked),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          // 3 Stars rating
                          Row(
                            children: List.generate(3, (starIdx) {
                              final isEarned = starIdx < stars;
                              return Icon(
                                isEarned ? Icons.star_rounded : Icons.star_border_rounded,
                                size: 18,
                                color: isEarned ? AppColors.accent : Colors.grey.withOpacity(0.4),
                              );
                            }),
                          ),
                          if (bestScore > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              'Skor: $bestScore',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}
