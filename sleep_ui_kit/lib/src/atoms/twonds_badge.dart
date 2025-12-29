import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? color;

  const TwonDSBadge({
    super.key, 
    required this.text, 
    this.icon, 
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final baseColor = color ?? TwonDSColors.accentMoon;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: baseColor),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TwonDSTextStyles.labelHighlight.copyWith(
              fontSize: 11,
              color: baseColor,
            ),
          ),
        ],
      ),
    );
  }
}