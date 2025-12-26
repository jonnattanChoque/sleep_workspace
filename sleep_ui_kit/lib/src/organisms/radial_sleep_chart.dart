import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class RadialSleepChart extends StatelessWidget {
  final double userProgress;    
  final double partnerProgress; 
  final String label;

  const RadialSleepChart({
    super.key,
    required this.userProgress,
    required this.partnerProgress,
    this.label = "Sincronización",
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anillo Exterior: Usuario
          PieChart(
            PieChartData(
              startDegreeOffset: 270,
              sectionsSpace: 0,
              centerSpaceRadius: 100,
              sections: _createSections(userProgress, TwonDSColors.primaryNight),
            ),
          ),
          PieChart(
            PieChartData(
              startDegreeOffset: 270,
              sectionsSpace: 0,
              centerSpaceRadius: 75,
              sections: _createSections(partnerProgress, TwonDSColors.partnerColor),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${(userProgress * 100).toInt()}%",
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 28, 
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                label,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createSections(double progress, Color color) {
    return [
      PieChartSectionData(
        color: color,
        value: progress,
        showTitle: false,
        radius: 18,
        badgeWidget: progress > 0.9 ? const Icon(Icons.star, color: Colors.white, size: 12) : null,
      ),
      PieChartSectionData(
        color: TwonDSColors.surface,
        value: 1 - progress,
        showTitle: false,
        radius: 18,
      ),
    ];
  }
}