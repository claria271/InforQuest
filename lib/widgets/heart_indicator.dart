import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../utils/constants.dart';

class HeartIndicator extends StatelessWidget {
  final int livesLeft;
  final int maxLives;

  const HeartIndicator({
    super.key,
    required this.livesLeft,
    this.maxLives = AppConstants.livesPerAttempt,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxLives, (index) {
        final isAlive = index < livesLeft;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isAlive ? 1.0 : 0.85,
            child: Icon(
              isAlive ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isAlive ? AppColors.wrong : Colors.grey.withOpacity(0.4),
              size: 26,
            ),
          ),
        );
      }),
    );
  }
}
