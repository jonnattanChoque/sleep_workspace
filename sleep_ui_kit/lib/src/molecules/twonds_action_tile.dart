import 'package:flutter/material.dart';

class TwonDSActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final IconData? iconTap;
  final VoidCallback onTap;

  const TwonDSActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isLight ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.3) : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.edit_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}