import 'package:flutter/material.dart';

class TwonDSSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const TwonDSSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon, 
        color: colorScheme.onSurface.withValues(alpha: 0.7), 
        size: 22
      ),
      title: Text(
        title,
        style: TextStyle(
          color: colorScheme.onSurface, 
          fontWeight: FontWeight.w500
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: colorScheme.primary, 
        activeTrackColor: colorScheme.primary.withValues(alpha: 0.3),
        inactiveThumbColor: colorScheme.onSurface.withValues(alpha: 0.6),
        inactiveTrackColor: colorScheme.onSurface.withValues(alpha: 0.1),
      ),
    );
  }
}