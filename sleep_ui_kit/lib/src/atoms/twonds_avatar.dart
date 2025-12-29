import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

// lib/components/atoms/avatar.dart

class TwonDSAvatar extends StatelessWidget {
  final String? imageUrl;
  final IconData defaultIcon;
  final double radius;
  final Color? backgroundColor;
  final Color? iconColor;

  const TwonDSAvatar({
    super.key,
    this.imageUrl,
    this.defaultIcon = TwonDSIcons.person,
    this.radius = 32,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? TwonDSColors.accentMoon.withValues(alpha: 0.1);
    final iColor = iconColor ?? TwonDSColors.accentMoon;

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        image: imageUrl != null && imageUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null || imageUrl!.isEmpty
          ? Icon(
              defaultIcon,
              color: iColor,
              size: radius,
            )
          : null,
    );
  }
}