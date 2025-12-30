import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSUserHeader extends StatelessWidget {
  final String name;
  final String email;
  final Widget? bottomChild;
  final Widget? avatar;

  const TwonDSUserHeader({
    super.key,
    required this.name,
    required this.email,
    this.bottomChild,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isLight 
            ? colorScheme.surface 
            : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.onSurface.withValues(alpha: 0.1)
        ),
      ),
      child: Row(
        children: [
          avatar ?? const SizedBox.shrink(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name, 
                  style: TwonDSTextStyles.h2(context)
                ),
                Text(
                  email, 
                  style: TwonDSTextStyles.bodyMedium(context)
                ),
                if (bottomChild != null) ...[
                  const SizedBox(height: 12),
                  bottomChild!,
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}