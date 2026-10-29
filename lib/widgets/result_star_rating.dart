import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ResultStarRating extends StatelessWidget {
  final int stars; // 0..3
  final double starSize;

  const ResultStarRating({
    super.key,
    required this.stars,
    this.starSize = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isEarned = index < stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: AnimatedScale(
            duration: Duration(milliseconds: 300 + (index * 150)),
            scale: isEarned ? 1.0 : 0.85,
            child: Icon(
              isEarned ? Icons.star_rounded : Icons.star_border_rounded,
              color: isEarned ? AppColors.accent : Colors.grey.withOpacity(0.3),
              size: starSize,
            ),
          ),
        );
      }),
    );
  }
}
