import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

enum AnswerState { idle, selected, correct, wrong }

class AnswerOptionCard extends StatelessWidget {
  final int index;
  final String text;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerOptionCard({
    super.key,
    required this.index,
    required this.text,
    required this.state,
    this.onTap,
  });

  String get _optionLabel {
    const labels = ['A', 'B', 'C', 'D'];
    return index < labels.length ? labels[index] : '${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;
    Color textColor;
    IconData? indicatorIcon;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (state) {
      case AnswerState.correct:
        borderColor = AppColors.correct;
        bgColor = AppColors.correct.withOpacity(0.15);
        textColor = isDark ? Colors.white : const Color(0xFF15803D);
        indicatorIcon = Icons.check_circle_rounded;
        break;
      case AnswerState.wrong:
        borderColor = AppColors.wrong;
        bgColor = AppColors.wrong.withOpacity(0.15);
        textColor = isDark ? Colors.white : const Color(0xFFB91C1C);
        indicatorIcon = Icons.cancel_rounded;
        break;
      case AnswerState.selected:
        borderColor = AppColors.primary;
        bgColor = AppColors.primary.withOpacity(0.12);
        textColor = isDark ? Colors.white : AppColors.primaryDark;
        indicatorIcon = Icons.radio_button_checked_rounded;
        break;
      case AnswerState.idle:
      default:
        borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
        bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        textColor = isDark ? AppColors.textLight : AppColors.textDark;
        indicatorIcon = null;
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: state == AnswerState.idle ? 1.5 : 2.0),
              boxShadow: [
                if (state == AnswerState.idle)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: state == AnswerState.idle
                        ? (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9))
                        : borderColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _optionLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: state == AnswerState.idle ? AppColors.textMuted : borderColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: state != AnswerState.idle ? FontWeight.w600 : FontWeight.normal,
                      color: textColor,
                    ),
                  ),
                ),
                if (indicatorIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(indicatorIcon, color: borderColor, size: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
