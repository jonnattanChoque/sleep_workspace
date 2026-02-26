import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class SleepShowcase extends StatelessWidget {
  final GlobalKey showcaseKey;
  final String title;
  final String description;
  final Widget child;

  const SleepShowcase({super.key, 
    required this.showcaseKey,
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: showcaseKey,
      title: title,
      description: description,
      targetPadding: const EdgeInsets.all(8),
      targetBorderRadius: BorderRadius.circular(12),
      tooltipBackgroundColor: Theme.of(context).colorScheme.surface,
      titleTextStyle: TwonDSTextStyles.h2(context),
      descTextStyle: TwonDSTextStyles.bodySmall(context),
      child: child,
    );
  }
}

enum AppTour {
  dashboard,
  history,
  profile
}