import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSStatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final double height;
  final IconData? iconTap;
  final VoidCallback onTap;

  const TwonDSStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.iconTap,
    this.height = 140,
    this.valueColor = const Color(0xFF3F51B5),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: TwonDSColors.accentMoon, 
                        fontSize: 14, 
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Icon(
                        iconTap ?? Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.white70,
                      ),
                    ),
                  ]
                ),
                const SizedBox(height: 32), 
                FittedBox(
                  child: Text(
                    value,
                    style: TwonDSTextStyles.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}