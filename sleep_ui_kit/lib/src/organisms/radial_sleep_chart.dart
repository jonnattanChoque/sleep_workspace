import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';
import 'package:flutter/services.dart';

class TwonDSRadialChart extends StatefulWidget {
  final String label;
  final double progress;
  final String lottiePath;
  final Color color;
  final VoidCallback? onTap;

  const TwonDSRadialChart({
    super.key,
    required this.label,
    required this.progress,
    required this.lottiePath,
    required this.color,
    this.onTap,
  });

  @override
  State<TwonDSRadialChart> createState() => _InteractiveSleepChartState();
}

class _InteractiveSleepChartState extends State<TwonDSRadialChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTapDown: (_) => _setTouched(0),
          onTapUp: (_) {
            _setTouched(-1);
            HapticFeedback.mediumImpact();
            widget.onTap?.call();
          },
          onTapCancel: () => _setTouched(-1),
          child: SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        if (event is FlTapDownEvent) _setTouched(0);
                        if (event is FlTapUpEvent) {
                          _setTouched(-1);
                          widget.onTap?.call();
                        }
                      },
                    ),
                    startDegreeOffset: 270,
                    sectionsSpace: 0,
                    centerSpaceRadius: 50,
                    sections: _showingSections(),
                  ),
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
                IgnorePointer(
                  child: Lottie.asset(widget.lottiePath, width: 70, height: 70),
                ),
                Lottie.asset(widget.lottiePath, width: 70, height: 70),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(widget.label, style: TwonDSTextStyles.bodyMedium(context).copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  List<PieChartSectionData> _showingSections() {
    final isTouched = touchedIndex == 0;
    final radius = isTouched ? 22.0 : 14.0;

    return [
      PieChartSectionData(
        color: widget.color,
        value: widget.progress * 100,
        radius: radius,
        showTitle: false,
      ),
      // Sección de Fondo
      PieChartSectionData(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        value: (1 - widget.progress) * 100,
        radius: 14,
        showTitle: false,
      ),
    ];
  }

  void _setTouched(int index) => setState(() => touchedIndex = index);
}