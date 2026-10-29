import 'package:flutter/material.dart';
import '../models/level.dart';
import '../models/user_progress.dart';
import '../utils/app_theme.dart';

class LockedLevelDialog extends StatelessWidget {
  final LevelModel level;
  final UserProgress progress;
  final int totalPrevSections;
  final VoidCallback onGoToPrevLevel;

  const LockedLevelDialog({
    super.key,
    required this.level,
    required this.progress,
    required this.totalPrevSections,
    required this.onGoToPrevLevel,
  });

  @override
  Widget build(BuildContext context) {
    final prevLvlId = level.id - 1;
    final prevLp = progress.levels[prevLvlId];
    final prevPassed = prevLp?.passed ?? false;
    final readCount = prevLp?.materialsRead.length ?? 0;
    final allRead = readCount >= totalPrevSections;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_rounded, color: AppColors.locked, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Level ${level.id} Terkunci',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Untuk membuka "${level.title}", selesaikan syarat di Level $prevLvlId terlebih dahulu:',
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
          const SizedBox(height: 16),
          // Condition 1: Pass Level N-1
          Row(
            children: [
              Icon(
                prevPassed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: prevPassed ? AppColors.correct : AppColors.locked,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Lulus Level $prevLvlId (Nilai minimal 80)',
                  style: TextStyle(
                    fontWeight: prevPassed ? FontWeight.w600 : FontWeight.normal,
                    color: prevPassed ? AppColors.correct : null,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Condition 2: Read all materials
          Row(
            children: [
              Icon(
                allRead ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: allRead ? AppColors.correct : AppColors.locked,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Membaca materi Level $prevLvlId ($readCount/$totalPrevSections bagian)',
                  style: TextStyle(
                    fontWeight: allRead ? FontWeight.w600 : FontWeight.normal,
                    color: allRead ? AppColors.correct : null,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onGoToPrevLevel();
          },
          child: Text('Buka Level $prevLvlId'),
        ),
      ],
    );
  }
}
