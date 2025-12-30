import 'package:flutter/material.dart';

class TwonDSTextStyles {
  
  static TextStyle h1(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static TextStyle h2(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSurface,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelHighlight(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static TextStyle brandLogo(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: 4.0,
  );
  
  static TextStyle brandLogoMini(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: 4.0,
  );

  static TextStyle displayCode(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.primary,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 6.0,
  );

  static TextStyle textSmall(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle buttonLarge(BuildContext context) => TextStyle(
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
}