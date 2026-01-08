import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

// design_system/widgets/twon_ds_expanded_tile.dart

class TwonDSExpandedTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? body;
  final Widget? trailing;
  final VoidCallback? onClose;

  const TwonDSExpandedTile({
    super.key,
    required this.leading,
    required this.title,
    this.subtitle,
    this.body,
    this.trailing,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isLight 
                ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.6) 
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: TwonDSTextStyles.h2(context)),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TwonDSTextStyles.bodySmall(context).copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    if (body != null) ...[
                      const SizedBox(height: 8),
                      body!,
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
        
        // El botón de cerrar posicionado en la esquina
        if (onClose != null)
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClose,
              splashRadius: 20,
              visualDensity: VisualDensity.compact,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
      ],
    );
  }
}