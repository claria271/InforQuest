import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../../data/achievement_definitions.dart';
import '../../models/level.dart';
import '../../models/question.dart';
import '../../models/quiz_result.dart';
import '../../utils/app_theme.dart';
import '../../utils/helpers.dart';
import '../../utils/routes.dart';
import '../../widgets/result_star_rating.dart';

class ResultScreen extends StatefulWidget {
  final LevelModel level;
  final QuizResult result;
  final List<QuestionModel> questions;

  const ResultScreen({
    super.key,
    required this.level,
    required this.result,
    required this.questions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (widget.result.passed) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final level = widget.level;
    final stars = AppHelpers.calculateStars(result.score);
    final hasNextLevel = level.id < 10;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Kuis Level ${level.id}'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Score Hero Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: result.passed ? AppColors.correct.withOpacity(0.4) : AppColors.wrong.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (result.passed ? AppColors.correct : AppColors.wrong).withOpacity(0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        result.passed ? '🎉 Selamat! Anda Lulus' : '😔 Belum Mencapai Target',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: result.passed ? AppColors.correct : AppColors.wrong,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        result.passed
                            ? 'Luar biasa! Skor Anda memenuhi batas kelulusan (>= 80).'
                            : 'Batas kelulusan adalah 80. Pelajari kembali materi dan coba lagi!',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 20),
                      // Large Score Display
                      Text(
                        '${result.score}',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: result.passed ? AppColors.correct : AppColors.wrong,
                        ),
                      ),
                      Text(
                        '${result.correctCount} dari ${result.totalCount} Soal Benar',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      ResultStarRating(stars: stars, starSize: 32),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      // Rewards summary row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildRewardBadge(
                            icon: Icons.bolt_rounded,
                            label: '+${result.xpEarned} XP',
                            color: AppColors.accent,
                          ),
                          _buildRewardBadge(
                            icon: Icons.monetization_on_rounded,
                            label: '+${result.coinsEarned} Koin',
                            color: AppColors.accent,
                          ),
                          _buildRewardBadge(
                            icon: Icons.favorite_rounded,
                            label: '${result.livesLeft} Nyawa Sisa',
                            color: AppColors.wrong,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Newly Earned Badges
                if (result.newBadges.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accent.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🎖️', style: TextStyle(fontSize: 22)),
                            SizedBox(width: 8),
                            Text(
                              'Lencana Baru Berhasil Dibuka!',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ...result.newBadges.map((badgeId) {
                          final b = AchievementDefinitions.getById(badgeId);
                          if (b == null) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Row(
                              children: [
                                Text(b.icon, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(b.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(b.description, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.quiz,
                            arguments: level.id,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Ulangi Kuis'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (result.passed && hasNextLevel)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.levelDetail,
                              arguments: level.id + 1,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Level Berikutnya'),
                        ),
                      )
                    else
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.mainShell,
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Kembali ke Peta'),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 28),

                // Comprehensive Breakdown Header
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pembahasan Lengkap Soal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 12),

                // Question Explanations List
                ...List.generate(widget.questions.length, (idx) {
                  final q = widget.questions[idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${idx + 1}. ${q.text}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text('Jawaban benar: ', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                            Expanded(
                              child: Text(
                                q.options[q.correctIndex],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.correct,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '💡 Pembahasan: ${q.explanation}',
                            style: const TextStyle(fontSize: 12.5, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Confetti display
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
                AppColors.correct,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardBadge({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
