import 'package:flutter/material.dart';

class TwonDSModalTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? color;
  final IconData? iconTab;
  final VoidCallback onTap;

  const TwonDSModalTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.color,
    this.iconTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color baseColor = color ?? colorScheme.onSurface;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon, 
        color: baseColor.withValues(alpha: color != null ? 1.0 : 0.7), 
        size: 22
      ),
      title: Text(
        title,
        style: TextStyle(
          color: baseColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing!,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.38), 
                fontSize: 14
              ),
            ),
          const SizedBox(width: 8),
          Icon(
            iconTab ?? Icons.chevron_right, 
            size: 18, 
            color: colorScheme.onSurface.withValues(alpha: 0.24)
          ),
        ],
      ),
    );
  }
}