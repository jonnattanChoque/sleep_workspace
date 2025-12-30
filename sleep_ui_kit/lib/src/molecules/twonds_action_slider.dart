import 'package:flutter/material.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class TwonDSActionSlider extends StatefulWidget {
  final String label;
  final String placeholder;
  final VoidCallback onAction;

  const TwonDSActionSlider({
    super.key,
    required this.label,
    required this.placeholder,
    required this.onAction,
  });

  @override
  State<TwonDSActionSlider> createState() => _TwonDSActionSliderState();
}

class _TwonDSActionSliderState extends State<TwonDSActionSlider> {
  double _position = 0;
  bool _isDragging = false;
  
  final double _size = 60.0; 
  final double _padding = 0.0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double buttonSize = _size;
        double maxSlide = maxWidth - buttonSize - (_padding );

        return Column(
          children: [
            Text(
              widget.label,
              style: TwonDSTextStyles.bodySmall(context),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: _size,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(_size / 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_size / 2),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: _isDragging ? 0 : 300),
                      curve: Curves.easeOutCubic,
                      width: _position > 0 
                          ? _position + (buttonSize / 2) + _padding 
                          : 0,
                      height: _size,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.placeholder.toUpperCase(),
                        style: TextStyle(
                          color: _position > (maxSlide / 2) 
                              ? Colors.white 
                              : colorScheme.onSurface.withValues(alpha: 0.24),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: _isDragging ? 0 : 300),
                      curve: Curves.easeOutCubic,
                      left: _position + _padding,
                      child: GestureDetector(
                        onHorizontalDragStart: (_) => setState(() => _isDragging = true),
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _position += details.delta.dx;
                            if (_position < 0) _position = 0;
                            if (_position > maxSlide) _position = maxSlide;
                          });
                        },
                        onHorizontalDragEnd: (details) {
                          setState(() => _isDragging = false);
                          if (_position > maxSlide * 0.9) {
                            widget.onAction();
                          }
                          setState(() => _position = 0);
                        },
                        child: Container(
                          width: buttonSize,
                          height: buttonSize,
                          margin: EdgeInsets.symmetric(vertical: _padding),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.link_off_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}