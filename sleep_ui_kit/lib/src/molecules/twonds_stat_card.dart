import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final double height;
  final IconData? iconTap;
  final IconData? centerIcon;
  final VoidCallback? onTap;

  const TwonDSStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.iconTap,
    this.centerIcon,
    this.height = 140,
    this.valueColor, 
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accentColor = TwonDSColors.accentMoon;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.3), 
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.1)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: isDark ? accentColor : colorScheme.onSurface, 
                          fontSize: 14, 
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Icon(
                      iconTap,
                      size: 17,
                      color: isDark 
                          ? colorScheme.onSurface.withValues(alpha: 0.7)
                          : colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ]
                ),
                if (centerIcon != null) ...[
                  const Spacer(),
                  Icon(
                    centerIcon,
                    size: 30,
                    color: (valueColor ?? accentColor).withAlpha(180),
                  ),
                ],
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    value,
                    style: TwonDSTextStyles.h2(context).copyWith(
                      color: valueColor ?? colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}