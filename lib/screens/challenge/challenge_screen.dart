import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/level.dart';
import '../../providers/progress_provider.dart';
import '../../utils/app_theme.dart';

class ChallengeScreen extends ConsumerStatefulWidget {
  final int levelId;

  const ChallengeScreen({super.key, required this.levelId});

  @override
  ConsumerState<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends ConsumerState<ChallengeScreen> {
  LevelModel? _level;
  Map<String, dynamic>? _challengeData;
  bool _isLoading = true;
  bool _isSuccess = false;
  String _feedbackMessage = '';

  // Generic reorderable steps state
  List<String> _currentStepItems = [];
  List<String> _targetOrder = [];

  @override
  void initState() {
    super.initState();
    _loadChallenge();
  }

  Future<void> _loadChallenge() async {
    final service = ref.read(contentServiceProvider);
    final lvl = await service.getLevelById(widget.levelId);
    final challenge = await service.getChallenge(widget.levelId);

    if (mounted) {
      setState(() {
        _level = lvl;
        _challengeData = challenge;
        _isLoading = false;
        _setupInteractiveState();
      });
    }
  }

  void _setupInteractiveState() {
    if (_challengeData == null) return;
    final type = _challengeData!['type'] as String?;

    if (type == 'order_steps') {
      final steps = (_challengeData!['steps'] as List)
          .map((e) => e['text'].toString())
          .toList();
      _targetOrder = List.from(steps);
      _currentStepItems = List.from(steps)..shuffle();
    } else if (type == 'code_blocks') {
      final blocks = (_challengeData!['blocks'] as List)
          .map((e) => e['code'].toString())
          .toList();
      _targetOrder = List.from(blocks);
      _currentStepItems = List.from(blocks)..shuffle();
    } else if (type == 'simulate_stack') {
      final correct = (_challengeData!['correctOrder'] as List)
          .map((e) => e.toString())
          .toList();
      _targetOrder = List.from(correct);
      _currentStepItems = ['A', 'B', 'C']..shuffle();
    } else if (type == 'connect_devices') {
      final path = (_challengeData!['path'] as List)
          .map((e) => e['node'].toString())
          .toList();
      _targetOrder = List.from(path);
      _currentStepItems = List.from(path)..shuffle();
    } else if (type == 'query_builder') {
      final fragments = (_challengeData!['fragments'] as List)
          .map((e) => e['text'].toString())
          .toList();
      _targetOrder = List.from(fragments);
      _currentStepItems = List.from(fragments)..shuffle();
    } else if (type == 'final_boss') {
      final layers = (_challengeData!['layers'] as List)
          .map((e) => e['name'].toString())
          .toList();
      _targetOrder = List.from(layers);
      _currentStepItems = List.from(layers)..shuffle();
    } else {
      // Default fallback
      _targetOrder = ['Langkah 1', 'Langkah 2', 'Langkah 3'];
      _currentStepItems = ['Langkah 2', 'Langkah 1', 'Langkah 3'];
    }
  }

  void _verifyOrderChallenge() async {
    bool isMatch = true;
    for (int i = 0; i < _targetOrder.length; i++) {
      if (_currentStepItems[i] != _targetOrder[i]) {
        isMatch = false;
        break;
      }
    }

    if (isMatch) {
      final awarded = await ref.read(progressProvider.notifier).completeChallenge(
            levelId: widget.levelId,
            totalMaterialsPerLevel: {widget.levelId: 4},
          );
      setState(() {
        _isSuccess = true;
        _feedbackMessage = awarded > 0
            ? 'Hebat! Urutan Anda tepat dan Anda mendapatkan +$awarded XP bonus!'
            : 'Tepat sekali! Anda telah menyelesaikan tantangan ini sebelumnya.';
      });
    } else {
      setState(() {
        _isSuccess = false;
        _feedbackMessage = 'Urutan masih belum tepat. Silakan susun ulang dan coba lagi!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _level == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final title = _challengeData?['title'] as String? ?? 'Tantangan Mini-Game';
    final instruction = _challengeData?['instruction'] as String? ?? 'Selesaikan tantangan berikut.';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology_rounded, color: AppColors.secondary, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Tantangan Interaktif Level ${widget.levelId}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      instruction,
                      style: const TextStyle(fontSize: 13.5, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Geser dan urutkan item berikut ke urutan yang benar:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textMuted),
              ),
              const SizedBox(height: 12),

              // Interactive Reorderable List
              Expanded(
                child: ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) newIndex -= 1;
                      final item = _currentStepItems.removeAt(oldIndex);
                      _currentStepItems.insert(newIndex, item);
                    });
                  },
                  children: [
                    for (int i = 0; i < _currentStepItems.length; i++)
                      Container(
                        key: ValueKey(_currentStepItems[i]),
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                _currentStepItems[i],
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const Icon(Icons.drag_handle_rounded, color: AppColors.textMuted),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Feedback banner
              if (_feedbackMessage.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: _isSuccess ? AppColors.correct.withOpacity(0.15) : AppColors.wrong.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isSuccess ? AppColors.correct : AppColors.wrong,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle_rounded : Icons.error_outline_rounded,
                        color: _isSuccess ? AppColors.correct : AppColors.wrong,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _feedbackMessage,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _isSuccess ? AppColors.correct : AppColors.wrong,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Verify button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _verifyOrderChallenge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isSuccess ? AppColors.correct : AppColors.primary,
                  ),
                  child: Text(_isSuccess ? 'Tantangan Selesai ✅' : 'Periksa Susunan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
