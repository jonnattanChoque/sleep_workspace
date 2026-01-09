import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSBanner extends StatelessWidget {
  final String text;
  final String actionLabel;
  final VoidCallback onTap;
  final IconData icon;

  const TwonDSBanner({
    super.key,
    required this.text,
    required this.actionLabel,
    required this.onTap,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TwonDSTextStyles.bodySmall(context).copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }
}