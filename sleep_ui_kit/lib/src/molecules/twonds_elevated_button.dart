import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSElevatedButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
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
          disabledBackgroundColor: isLoading 
              ? colorScheme.primary.withValues(alpha: 0.6) 
              : colorScheme.onSurface.withValues(alpha: 0.12),
        ),
        child: isLoading 
          ? SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Theme.of(context).brightness == Brightness.dark 
                    ? colorScheme.onPrimary 
                    : Colors.white, 
                strokeWidth: 3,
              ),
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