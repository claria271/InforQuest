import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/level.dart';
import '../../models/material_section.dart';
import '../../providers/progress_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/routes.dart';
import '../../widgets/result_star_rating.dart';

class LevelDetailScreen extends ConsumerStatefulWidget {
  final int levelId;

  const LevelDetailScreen({super.key, required this.levelId});

  @override
  ConsumerState<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends ConsumerState<LevelDetailScreen> {
  LevelModel? _level;
  List<MaterialSection> _materials = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final contentService = ref.read(contentServiceProvider);
    final lvl = await contentService.getLevelById(widget.levelId);
    final mats = await contentService.getMaterials(widget.levelId);
    if (mounted) {
      setState(() {
        _level = lvl;
        _materials = mats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_level == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Level tidak ditemukan')),
      );
    }

    final level = _level!;
    final progress = ref.watch(progressProvider);
    final lp = progress.levels[level.id];
    final readList = lp?.materialsRead ?? [];
    final allRead = _materials.isNotEmpty && readList.length >= _materials.length;
    final isPassed = lp?.passed ?? false;
    final stars = lp?.stars ?? 0;
    final bestScore = lp?.bestScore ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${level.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level Card Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isPassed ? AppColors.correct.withOpacity(0.4) : AppColors.primary.withOpacity(0.3),
                  width: 1.5,
                ),
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
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          level.difficulty.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.bolt_rounded, size: 14, color: AppColors.accent),
                                Text(
                                  '+${level.rewardXp} XP',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.monetization_on_rounded, size: 14, color: AppColors.accent),
                                const SizedBox(width: 2),
                                Text(
                                  '+${level.rewardCoins}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    level.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    level.objective,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Nilai Terbaik', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          Text(
                            '$bestScore / 100',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: bestScore >= 80 ? AppColors.correct : null,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Bintang', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          ResultStarRating(stars: stars, starSize: 22),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Status', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          Text(
                            isPassed ? 'Lulus ✅' : 'Belum Lulus',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isPassed ? AppColors.correct : AppColors.wrong,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Material Sections Checklist
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Daftar Materi (${readList.length}/${_materials.length} Selesai)',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.material,
                      arguments: level.id,
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.menu_book_rounded, size: 16),
                  label: const Text('Buka'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._materials.map((mat) {
              final isRead = readList.contains(mat.id);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isRead ? AppColors.correct.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                  ),
                ),
                child: ListTile(
                  leading: Icon(
                    isRead ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                    color: isRead ? AppColors.correct : AppColors.locked,
                  ),
                  title: Text(
                    mat.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isRead ? null : AppColors.textMuted,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.material,
                      arguments: level.id,
                    ).then((_) => _loadData());
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            // Mini-game Challenge Banner
            if (level.challengeTitle != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.extension_rounded, color: AppColors.secondary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.challengeTitle!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lp?.challengeRewarded ?? false
                                ? 'Tantangan sudah diselesaikan (+20 XP)'
                                : 'Mini-game interaktif berhadiah bonus +20 XP',
                            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.challenge,
                          arguments: level.id,
                        ).then((_) => _loadData());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      ),
                      child: Text(lp?.challengeRewarded ?? false ? 'Buka' : 'Mainkan'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  if (!allRead) {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Row(
                          children: [
                            Icon(Icons.info_outline_rounded, color: AppColors.accent),
                            SizedBox(width: 8),
                            Text('Materi Belum Lengkap'),
                          ],
                        ),
                        content: const Text(
                          'Sangat disarankan membaca seluruh materi sebelum kuis agar Anda lulus (nilai >= 80) dan membuka level selanjutnya.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.pushNamed(context, AppRoutes.material, arguments: level.id);
                            },
                            child: const Text('Baca Materi Sekarang'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.pushNamed(context, AppRoutes.quiz, arguments: level.id);
                            },
                            child: const Text('Tetap Mulai Kuis'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    Navigator.pushNamed(context, AppRoutes.quiz, arguments: level.id);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.quiz_rounded),
                    const SizedBox(width: 8),
                    Text(
                      isPassed ? 'Ulangi Kuis (Tingkatkan Skor)' : 'Mulai Kuis Level ${level.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.material,
                    arguments: level.id,
                  ).then((_) => _loadData());
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Baca Semua Materi'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
