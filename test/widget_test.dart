import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infoquest/widgets/answer_option.dart';
import 'package:infoquest/widgets/heart_indicator.dart';
import 'package:infoquest/widgets/streak_chip.dart';
import 'package:infoquest/widgets/xp_bar.dart';

void main() {
  testWidgets('HeartIndicator displays 3 hearts with 2 active when livesLeft is 2', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: HeartIndicator(livesLeft: 2, maxLives: 3),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(2));
    expect(find.byIcon(Icons.favorite_border_rounded), findsNWidgets(1));
  });

  testWidgets('StreakChip renders streak count and flame emoji', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StreakChip(streak: 4),
        ),
      ),
    );

    expect(find.text('4 Hari'), findsOneWidget);
    expect(find.text('🔥'), findsOneWidget);
  });

  testWidgets('XpBar renders rank name and total XP', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: XpBar(totalXp: 350, coins: 50),
        ),
      ),
    );

    expect(find.text('Penjelajah'), findsOneWidget);
    expect(find.text('350 XP'), findsOneWidget);
    expect(find.text('50'), findsOneWidget);
  });

  testWidgets('AnswerOptionCard renders text and triggers callback on tap', (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnswerOptionCard(
            index: 0,
            text: 'Algoritma Pemrograman',
            state: AnswerState.idle,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('Algoritma Pemrograman'), findsOneWidget);

    await tester.tap(find.byType(AnswerOptionCard));
    expect(tapped, isTrue);
  });
}
