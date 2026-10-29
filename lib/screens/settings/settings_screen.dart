import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/progress_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _confirmResetProgress(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.wrong),
            SizedBox(width: 8),
            Text('Reset Semua Progres?'),
          ],
        ),
        content: const Text(
          'Tindakan ini akan menghapus seluruh XP, koin, riwayat kuis, bintang, dan lencana yang telah Anda kumpulkan. Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(progressProvider.notifier).resetProgress();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Seluruh progres belajar telah direset ke awal.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.wrong),
            child: const Text('Ya, Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preferensi Aplikasi',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                    title: const Text('Tema Gelap (Dark Mode)'),
                    subtitle: const Text('Mengurangi silau cahaya di malam hari'),
                    value: settings.isDarkMode,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggleDarkMode(val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up_outlined, color: AppColors.secondary),
                    title: const Text('Efek Suara'),
                    subtitle: const Text('Suara saat menjawab kuis dan kelulusan'),
                    value: settings.isSoundEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggleSound(val);
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.vibration_rounded, color: AppColors.accent),
                    title: const Text('Getaran Haptik'),
                    subtitle: const Text('Getar umpan balik saat menjawab salah'),
                    value: settings.isVibrationEnabled,
                    onChanged: (val) {
                      ref.read(settingsProvider.notifier).toggleVibration(val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Data & Privasi',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                leading: const Icon(Icons.delete_forever_rounded, color: AppColors.wrong),
                title: const Text('Reset Seluruh Progres Belajar', style: TextStyle(color: AppColors.wrong, fontWeight: FontWeight.w600)),
                subtitle: const Text('Kembalikan level ke status awal terkunci'),
                onTap: () => _confirmResetProgress(context, ref),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              'Tentang InfoQuest',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Text('🚀', style: TextStyle(fontSize: 24)),
                      ),
                      const SizedBox(width: 14),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            'Versi 1.0.0 • Kurikulum Informatika',
                            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'InfoQuest adalah aplikasi mobile pembelajaran informatika berbasis gamifikasi interaktif. Dibuat dengan Flutter untuk pelajar Indonesia agar memahami konsep berpikir komputasional, algoritma, sistem komputer, jaringan, dan kecerdasan buatan dengan cara yang menyenangkan.',
                    style: TextStyle(fontSize: 13, height: 1.5, color: AppColors.textMuted),
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
