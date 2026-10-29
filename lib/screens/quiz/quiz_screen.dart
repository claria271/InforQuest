import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/level.dart';
import '../../providers/progress_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/routes.dart';
import '../../widgets/answer_option.dart';
import '../../widgets/heart_indicator.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final int levelId;

  const QuizScreen({super.key, required this.levelId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  LevelModel? _level;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initQuizSession();
  }

  Future<void> _initQuizSession() async {
    final service = ref.read(contentServiceProvider);
    final lvl = await service.getLevelById(widget.levelId);
    final questions = await service.getQuestions(widget.levelId);

    if (mounted) {
      setState(() {
        _level = lvl;
        _isLoading = false;
      });
      ref.read(quizProvider.notifier).initQuiz(questions);
    }
  }

  Future<bool> _onWillPop() async {
    final quizState = ref.read(quizProvider);
    if (quizState.isGameOver || quizState.isCompleted) return true;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Batalkan Kuis?'),
        content: const Text(
          'Jika Anda keluar sekarang, percobaan kuis ini dianggap dibatalkan dan tidak akan dicatat.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Lanjutkan Kuis'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.wrong),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  void _finishAndNavigateToResult(QuizState quizState) async {
    if (_level == null) return;
    final totalMats = {widget.levelId: 4}; // default fallback
    final result = await ref.read(progressProvider.notifier).recordQuizOutcome(
          level: _level!,
          correctCount: quizState.correctCount,
          totalCount: quizState.questions.length,
          livesLeft: quizState.livesLeft,
          totalMaterialsPerLevel: totalMats,
        );

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.result,
      arguments: {
        'level': _level,
        'result': result,
        'questions': quizState.questions,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _level == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final quizState = ref.watch(quizProvider);
    final currentQ = quizState.currentQuestion;

    if (currentQ == null && !quizState.isGameOver) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _onWillPop();
        if (shouldExit && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kuis Level ${_level!.id}'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: HeartIndicator(livesLeft: quizState.livesLeft),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6),
            child: LinearProgressIndicator(
              value: quizState.questions.isNotEmpty
                  ? (quizState.currentIndex + 1) / quizState.questions.length
                  : 0.0,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 4,
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question progress counter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soal ${quizState.currentIndex + 1} dari ${quizState.questions.length}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMuted),
                    ),
                    Text(
                      'Benar: ${quizState.correctCount}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.correct),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Question Box
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: Text(
                            currentQ?.text ?? '',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Options List
                        if (currentQ != null)
                          ...List.generate(currentQ.options.length, (optIdx) {
                            final optText = currentQ.options[optIdx];
                            AnswerState cardState = AnswerState.idle;

                            if (quizState.hasSubmittedAnswer) {
                              if (optIdx == currentQ.correctIndex) {
                                cardState = AnswerState.correct;
                              } else if (optIdx == quizState.selectedOptionIndex) {
                                cardState = AnswerState.wrong;
                              }
                            } else if (quizState.selectedOptionIndex == optIdx) {
                              cardState = AnswerState.selected;
                            }

                            return AnswerOptionCard(
                              index: optIdx,
                              text: optText,
                              state: cardState,
                              onTap: quizState.hasSubmittedAnswer
                                  ? null
                                  : () {
                                      ref.read(quizProvider.notifier).selectAndSubmitOption(optIdx);
                                    },
                            );
                          }),

                        // Explanation block if answered
                        if (quizState.hasSubmittedAnswer && currentQ != null) ...[
                          const SizedBox(height: 12),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: quizState.isCurrentCorrect
                                  ? AppColors.correct.withOpacity(0.12)
                                  : AppColors.wrong.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: quizState.isCurrentCorrect
                                    ? AppColors.correct.withOpacity(0.4)
                                    : AppColors.wrong.withOpacity(0.4),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      quizState.isCurrentCorrect
                                          ? Icons.check_circle_rounded
                                          : Icons.info_rounded,
                                      color: quizState.isCurrentCorrect ? AppColors.correct : AppColors.wrong,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      quizState.isCurrentCorrect ? 'Jawaban Anda Tepat!' : 'Jawaban Kurang Tepat',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: quizState.isCurrentCorrect ? AppColors.correct : AppColors.wrong,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  currentQ.explanation,
                                  style: const TextStyle(fontSize: 14, height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Next or Finish Button
                if (quizState.hasSubmittedAnswer) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (quizState.isGameOver) {
                          // Lives ended or finished
                          _finishAndNavigateToResult(quizState);
                        } else {
                          final hasNext = ref.read(quizProvider.notifier).nextQuestion();
                          if (!hasNext) {
                            final updatedState = ref.read(quizProvider);
                            _finishAndNavigateToResult(updatedState);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quizState.isGameOver && quizState.livesLeft <= 0
                            ? AppColors.wrong
                            : AppColors.primary,
                      ),
                      child: Text(
                        quizState.isGameOver
                            ? (quizState.livesLeft <= 0 ? 'Nyawa Habis • Lihat Hasil' : 'Selesai • Lihat Hasil')
                            : 'Lanjut ke Soal Berikutnya',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
