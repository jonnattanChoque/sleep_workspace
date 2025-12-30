import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwnDSConfirmDialog extends StatelessWidget {
  final String title;
  final String description;
  final String confirmText;
  final VoidCallback onConfirm;

  const TwnDSConfirmDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface, 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(title, style: TwonDSTextStyles.h2(context), textAlign: TextAlign.center),
      content: Text(
        description,
        style: TwonDSTextStyles.bodyMedium(context),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar', 
            style: TwonDSTextStyles.bodySmall(context).copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.54),
            )
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 0,
          ),
          child: Text(
            confirmText, 
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}