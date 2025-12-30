import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwnDSInputDialogModal extends StatelessWidget {
  final String title;
  final String description;
  final Widget inputField;
  final Widget actionButton;

  const TwnDSInputDialogModal({
    super.key,
    required this.title,
    required this.description,
    required this.inputField,
    required this.actionButton,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String description,
    required Widget inputField,
    required Widget actionButton,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => TwnDSInputDialogModal(
        title: title,
        description: description,
        inputField: inputField,
        actionButton: actionButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: TwonDSTextStyles.h2(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TwonDSTextStyles.labelHighlight(context),
          ),
          const SizedBox(height: 32),
          inputField,
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: actionButton,
          ),
        ],
      ),
    );
  }
}