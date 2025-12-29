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
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Icon(icon, color: Colors.white70, size: 22),
                const SizedBox(width: 16),
                Text(
                  title, 
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.w400
                  )
                ),
                const Spacer(),
                Icon(
                  iconTap ?? Icons.chevron_right, 
                  color: Colors.white.withValues(alpha: 0.3)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}