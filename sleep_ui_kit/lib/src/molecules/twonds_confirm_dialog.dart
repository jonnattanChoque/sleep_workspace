import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/src/atoms/twonds_colors.dart';
import 'package:sleep_ui_kit/src/atoms/twonds_text_styles.dart';

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
    return AlertDialog(
      backgroundColor: TwonDSColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      title: Text(title, style: TwonDSTextStyles.h2, textAlign: TextAlign.center),
      content: Text(
        description,
        style: TwonDSTextStyles.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancelar', 
            style: TwonDSTextStyles.bodySmall.copyWith(color: Colors.white54)
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: TwonDSColors.accentMoon,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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