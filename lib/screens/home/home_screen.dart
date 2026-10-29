import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/achievement_definitions.dart';
import '../../models/level.dart';
import '../../providers/progress_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/routes.dart';
import '../../widgets/streak_chip.dart';
import '../../widgets/xp_bar.dart';

class HomeScreen extends ConsumerWidget {
  final VoidCallback onNavigateToMap;

  const HomeScreen({super.key, required this.onNavigateToMap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final progress = ref.watch(progressProvider);
    final levelsAsync = ref.watch(levelsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              user?.avatar ?? '🚀',
              style: const TextStyle(fontSize: 26),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${user?.name ?? 'Penjelajah'}!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Siap menjelajah hari ini?',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: StreakChip(streak: progress.streak),
          ),
        ],
      ),
      body: levelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat: $err')),
        data: (levels) {
          // Find first unlocked level that is not passed yet
          LevelModel activeLevel = levels.first;
          for (final lvl in levels) {
            final lp = progress.levels[lvl.id];
            final isUnlocked = lp?.unlocked ?? (lvl.id == 1);
            final isPassed = lp?.passed ?? false;
            if (isUnlocked && !isPassed) {
              activeLevel = lvl;
              break;
            }
          }

          // Progress statistics
          int passedCount = 0;
          int totalStars = 0;
          progress.levels.forEach((_, lp) {
            if (lp.passed) passedCount++;
            totalStars += lp.stars;
          });

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(levelsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // XP & Rank Bar
                  XpBar(totalXp: progress.totalXp, coins: progress.coins),
                  const SizedBox(height: 24),

                  // "Lanjutkan Belajar" Hero Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                'Level Aktif • ${activeLevel.id}/10',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${activeLevel.rewardXp} XP',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          activeLevel.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activeLevel.objective,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.levelDetail,
                                arguments: activeLevel.id,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primaryDark,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Lanjutkan Belajar', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Overall Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatMiniCard(
                          context,
                          title: 'Kelulusan',
                          value: '$passedCount / 10',
                          subtitle: 'Level tuntas',
                          icon: Icons.check_circle_outline_rounded,
                          color: AppColors.correct,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatMiniCard(
                          context,
                          title: 'Bintang',
                          value: '$totalStars / 30',
                          subtitle: 'Bintang diraih',
                          icon: Icons.star_rounded,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Action shortcut cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jelajahi Fitur',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: onNavigateToMap,
                        child: const Text('Buka Peta Level'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          icon: Icons.bar_chart_rounded,
                          title: 'Statistik',
                          color: AppColors.secondary,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.statistics),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          icon: Icons.history_rounded,
                          title: 'Riwayat Kuis',
                          color: AppColors.primary,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.history),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFeatureCard(
                          context,
                          icon: Icons.settings_outlined,
                          title: 'Pengaturan',
                          color: AppColors.textMuted,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Recent Badges Row
                  Text(
                    'Lencana Terbaru',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (progress.earnedAchievements.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Belum ada lencana yang diraih. Selesaikan Level 1 untuk membuka lencana pertama!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 12,
                      children: progress.earnedAchievements.take(4).map((badgeId) {
                        final badge = AchievementDefinitions.getById(badgeId);
                        if (badge == null) return const SizedBox();
                        return Chip(
                          avatar: Text(badge.icon),
                          label: Text(badge.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                          backgroundColor: AppColors.accent.withOpacity(0.12),
                          side: BorderSide(color: AppColors.accent.withOpacity(0.4)),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatMiniCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
