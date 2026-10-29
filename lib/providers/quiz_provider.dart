import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/question.dart';
import '../utils/constants.dart';

class QuizState {
  final List<QuestionModel> questions;
  final int currentIndex;
  final int livesLeft;
  final int correctCount;
  final int? selectedOptionIndex;
  final bool hasSubmittedAnswer;
  final bool isGameOver; // lives == 0 or completed
  final bool isCompleted; // answered all questions

  const QuizState({
    required this.questions,
    this.currentIndex = 0,
    this.livesLeft = AppConstants.livesPerAttempt,
    this.correctCount = 0,
    this.selectedOptionIndex,
    this.hasSubmittedAnswer = false,
    this.isGameOver = false,
    this.isCompleted = false,
  });

  QuestionModel? get currentQuestion {
    if (questions.isEmpty || currentIndex >= questions.length) return null;
    return questions[currentIndex];
  }

  bool get isCurrentCorrect {
    if (currentQuestion == null || selectedOptionIndex == null) return false;
    return selectedOptionIndex == currentQuestion!.correctIndex;
  }

  QuizState copyWith({
    List<QuestionModel>? questions,
    int? currentIndex,
    int? livesLeft,
    int? correctCount,
    int? selectedOptionIndex,
    bool? hasSubmittedAnswer,
    bool? isGameOver,
    bool? isCompleted,
    bool clearSelected = false,
  }) {
    return QuizState(
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      livesLeft: livesLeft ?? this.livesLeft,
      correctCount: correctCount ?? this.correctCount,
      selectedOptionIndex: clearSelected ? null : (selectedOptionIndex ?? this.selectedOptionIndex),
      hasSubmittedAnswer: hasSubmittedAnswer ?? this.hasSubmittedAnswer,
      isGameOver: isGameOver ?? this.isGameOver,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(const QuizState(questions: []));

  void initQuiz(List<QuestionModel> questions) {
    // Shuffle questions or keep as is
    final shuffled = List<QuestionModel>.from(questions)..shuffle();
    state = QuizState(
      questions: shuffled,
      currentIndex: 0,
      livesLeft: AppConstants.livesPerAttempt,
      correctCount: 0,
      selectedOptionIndex: null,
      hasSubmittedAnswer: false,
      isGameOver: false,
      isCompleted: false,
    );
  }

  void selectAndSubmitOption(int index) {
    if (state.hasSubmittedAnswer || state.isGameOver) return;

    final q = state.currentQuestion;
    if (q == null) return;

    final isCorrect = (index == q.correctIndex);
    final newCorrect = isCorrect ? state.correctCount + 1 : state.correctCount;
    final newLives = isCorrect ? state.livesLeft : state.livesLeft - 1;
    final gameOver = newLives <= 0;

    state = state.copyWith(
      selectedOptionIndex: index,
      hasSubmittedAnswer: true,
      correctCount: newCorrect,
      livesLeft: newLives,
      isGameOver: gameOver,
    );
  }

  bool nextQuestion() {
    if (state.isGameOver) return false;

    final nextIdx = state.currentIndex + 1;
    if (nextIdx >= state.questions.length) {
      state = state.copyWith(
        isGameOver: true,
        isCompleted: true,
      );
      return false; // Quiz ended
    } else {
      state = state.copyWith(
        currentIndex: nextIdx,
        hasSubmittedAnswer: false,
        clearSelected: true,
      );
      return true; // Has next
    }
  }
}

final quizProvider = StateNotifierProvider.autoDispose<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});
