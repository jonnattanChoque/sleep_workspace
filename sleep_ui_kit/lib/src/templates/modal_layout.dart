import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSModalLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const TwonDSModalLayout({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          Text(title, style: TwonDSTextStyles.h2(context)),
          const SizedBox(height: 24),
          
          ...children,
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}