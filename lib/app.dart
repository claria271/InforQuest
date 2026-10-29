import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/level.dart';
import 'models/question.dart';
import 'models/quiz_result.dart';
import 'providers/settings_provider.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/challenge/challenge_screen.dart';
import 'screens/history/history_screen.dart';
import 'screens/level_detail/level_detail_screen.dart';
import 'screens/main_shell.dart';
import 'screens/material/material_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/quiz/quiz_screen.dart';
import 'screens/result/result_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/statistics/statistics_screen.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'utils/routes.dart';

class InfoQuestApp extends ConsumerWidget {
  const InfoQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.auth: (context) => const AuthScreen(),
        AppRoutes.mainShell: (context) => const MainShellScreen(),
        AppRoutes.history: (context) => const HistoryScreen(),
        AppRoutes.statistics: (context) => const StatisticsScreen(),
        AppRoutes.settings: (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.levelDetail) {
          final levelId = settings.arguments as int? ?? 1;
          return MaterialPageRoute(
            builder: (context) => LevelDetailScreen(levelId: levelId),
          );
        } else if (settings.name == AppRoutes.material) {
          final levelId = settings.arguments as int? ?? 1;
          return MaterialPageRoute(
            builder: (context) => MaterialScreen(levelId: levelId),
          );
        } else if (settings.name == AppRoutes.quiz) {
          final levelId = settings.arguments as int? ?? 1;
          return MaterialPageRoute(
            builder: (context) => QuizScreen(levelId: levelId),
          );
        } else if (settings.name == AppRoutes.challenge) {
          final levelId = settings.arguments as int? ?? 1;
          return MaterialPageRoute(
            builder: (context) => ChallengeScreen(levelId: levelId),
          );
        } else if (settings.name == AppRoutes.result) {
          final args = settings.arguments as Map<String, dynamic>;
          final level = args['level'] as LevelModel;
          final result = args['result'] as QuizResult;
          final questions = args['questions'] as List<QuestionModel>;
          return MaterialPageRoute(
            builder: (context) => ResultScreen(
              level: level,
              result: result,
              questions: questions,
            ),
          );
        }
        return null;
      },
    );
  }
}
