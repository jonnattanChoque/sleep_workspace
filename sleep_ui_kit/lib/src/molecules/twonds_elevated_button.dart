import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const TwonDSElevatedButton({
    super.key, 
    required this.text, 
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          disabledBackgroundColor: colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        child: isLoading 
          ? CircularProgressIndicator(
              color: colorScheme.onPrimary, 
              strokeWidth: 3,
            )
          : Text(
              text,
              style: TwonDSTextStyles.buttonLarge(context).copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
      ),
    );
  }
}