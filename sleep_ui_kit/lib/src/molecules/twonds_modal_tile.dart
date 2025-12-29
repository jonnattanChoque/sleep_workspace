import 'package:flutter/material.dart';

class TwonDSModalTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  final Color? color;
  final VoidCallback onTap;

  const TwonDSModalTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: color ?? Colors.white70, size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing!,
              style: const TextStyle(color: Colors.white38, fontSize: 14),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 18, color: Colors.white24),
        ],
      ),
    );
  }
}