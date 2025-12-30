import 'package:flutter/material.dart';

class TwonDSActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const TwonDSActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon, 
                color: colorScheme.onSurface, 
                size: 20
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label, 
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7), 
                fontSize: 12
              )
            ),
          ],
        ),
      ),
    );
  }
}