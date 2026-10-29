import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/progress_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/routes.dart';
import '../../widgets/level_node.dart';
import '../../widgets/locked_dialog.dart';

class LevelMapScreen extends ConsumerWidget {
  const LevelMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelsAsync = ref.watch(levelsProvider);
    final progress = ref.watch(progressProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Peta Petualangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: levelsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Gagal memuat peta: $err')),
        data: (levels) {
          // Identify the current active (next unpassed) level id
          int activeLvlId = 1;
          for (final lvl in levels) {
            final lp = progress.levels[lvl.id];
            final isUnlocked = lp?.unlocked ?? (lvl.id == 1);
            final isPassed = lp?.passed ?? false;
            if (isUnlocked && !isPassed) {
              activeLvlId = lvl.id;
              break;
            }
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];
              final lp = progress.levels[level.id];
              final isUnlocked = lp?.unlocked ?? (level.id == 1);
              final isNextActive = (level.id == activeLvlId);

              return Column(
                children: [
                  LevelNodeWidget(
                    level: level,
                    progress: lp,
                    isNextActive: isNextActive,
                    onTap: () {
                      if (isUnlocked) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.levelDetail,
                          arguments: level.id,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => LockedLevelDialog(
                            level: level,
                            progress: progress,
                            totalPrevSections: 4, // estimate / default
                            onGoToPrevLevel: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.levelDetail,
                                arguments: level.id - 1,
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  if (index < levels.length - 1)
                    Container(
                      width: 3,
                      height: 24,
                      decoration: BoxDecoration(
                        color: (progress.levels[level.id]?.passed ?? false)
                            ? AppColors.correct.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
