import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/material_section.dart';
import '../../providers/progress_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/routes.dart';

class MaterialScreen extends ConsumerStatefulWidget {
  final int levelId;

  const MaterialScreen({super.key, required this.levelId});

  @override
  ConsumerState<MaterialScreen> createState() => _MaterialScreenState();
}

class _MaterialScreenState extends ConsumerState<MaterialScreen> {
  final PageController _pageController = PageController();
  List<MaterialSection> _sections = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    final service = ref.read(contentServiceProvider);
    final list = await service.getMaterials(widget.levelId);
    if (mounted) {
      setState(() {
        _sections = list;
        _isLoading = false;
      });
      if (_sections.isNotEmpty) {
        _markCurrentRead(0);
      }
    }
  }

  void _markCurrentRead(int index) {
    if (index >= 0 && index < _sections.length) {
      final section = _sections[index];
      ref.read(progressProvider.notifier).markSectionRead(
            levelId: widget.levelId,
            sectionId: section.id,
            totalMaterialsPerLevel: {widget.levelId: _sections.length},
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_sections.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Tidak ada materi untuk level ini')),
      );
    }

    final isLast = _currentIndex == _sections.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Materi Level ${widget.levelId}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6),
          child: LinearProgressIndicator(
            value: (_currentIndex + 1) / _sections.length,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bagian ${_currentIndex + 1} dari ${_sections.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textMuted),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.correct.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle_rounded, size: 14, color: AppColors.correct),
                        SizedBox(width: 4),
                        Text('Dibaca', style: TextStyle(color: AppColors.correct, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Material Content PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _sections.length,
                onPageChanged: (idx) {
                  setState(() => _currentIndex = idx);
                  _markCurrentRead(idx);
                },
                itemBuilder: (context, index) {
                  final section = _sections[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: Text(
                            section.content,
                            style: const TextStyle(
                              fontSize: 15.5,
                              height: 1.7,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Navigation Bottom Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
              ),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Sebelumnya'),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        if (isLast) {
                          // Finish reading all, can jump directly to quiz
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.quiz,
                            arguments: widget.levelId,
                          );
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(isLast ? 'Mulai Kuis Level ${widget.levelId}' : 'Lanjut ke Bagian Berikutnya'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
