import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/achievement_definitions.dart';
import '../../models/achievement.dart';
import '../../providers/progress_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/badge_tile.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  void _showBadgeDetail(BuildContext context, Achievement badge, bool isEarned) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: isEarned ? AppColors.accent.withOpacity(0.18) : Colors.grey.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isEarned
                    ? Text(badge.icon, style: const TextStyle(fontSize: 42))
                    : const Icon(Icons.lock_rounded, size: 36, color: AppColors.locked),
              ),
              const SizedBox(height: 16),
              Text(
                badge.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                badge.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.4),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.accent, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      '+${badge.rewardXp} XP',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                    if (badge.rewardCoins > 0) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.monetization_on_rounded, color: AppColors.accent, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '+${badge.rewardCoins} Koin',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.accent),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEarned ? '✅ Sudah Anda Dapatkan' : '🔒 Belum Terbuka',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: isEarned ? AppColors.correct : AppColors.locked,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressProvider);
    const allBadges = AchievementDefinitions.allAchievements;
    final earnedCount = progress.earnedAchievements.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksi Lencana', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.military_tech_rounded, color: AppColors.accent, size: 36),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$earnedCount dari ${allBadges.length} Lencana',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Kumpulkan seluruh lencana dengan konsisten belajar dan menaklukkan tantangan!',
                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Semua Lencana',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemCount: allBadges.length,
              itemBuilder: (context, index) {
                final badge = allBadges[index];
                final isEarned = progress.earnedAchievements.contains(badge.id);
                return BadgeTileWidget(
                  achievement: badge,
                  isEarned: isEarned,
                  onTap: () => _showBadgeDetail(context, badge, isEarned),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
