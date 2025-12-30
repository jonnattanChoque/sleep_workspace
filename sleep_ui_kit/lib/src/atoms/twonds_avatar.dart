import 'package:flutter/material.dart';

class TwonDSAvatar extends StatelessWidget {
  final String? imageUrl;
  final IconData defaultIcon;
  final double radius;
  final Color? customBackgroundColor;
  final Color? customIconColor;

  const TwonDSAvatar({
    super.key,
    this.imageUrl,
    this.defaultIcon = Icons.person,
    this.radius = 32,
    this.customBackgroundColor,
    this.customIconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = customBackgroundColor ?? colorScheme.primary.withValues(alpha: 0.1);
    final iColor = customIconColor ?? colorScheme.primary;

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