import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSBadge extends StatelessWidget {
  final String text;
  final IconData? icon;
  final Color? customColor;

  const TwonDSBadge({
    super.key, 
    required this.text, 
    this.icon, 
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color moonColor = TwonDSColors.accentMoon;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: customColor ?? moonColor.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: moonColor.withValues(alpha: .6),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon, 
              size: 12, 
              color: TwonDSColors.primaryNight,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: TwonDSTextStyles.labelHighlight(context).copyWith(
              fontSize: 11,
              color: TwonDSColors.primaryNight,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}