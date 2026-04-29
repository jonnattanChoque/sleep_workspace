import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/chart_bars.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class DoubleBarChart extends StatelessWidget {
  final BarChartState stats;
  final int myGoalHours;
  final int partnerGoalHours;
  final String partnerName;

  const DoubleBarChart({super.key, 
    required this.stats, 
    required this.myGoalHours, 
    required this.partnerGoalHours,
    required this.partnerName,
  });

  @override
  Widget build(BuildContext context) {
    final double finalWidth = stats.calculatedWidth == 0.0 
        ? MediaQuery.of(context).size.width - 32 
        : stats.calculatedWidth;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: finalWidth,
        child: BarChart(
          BarChartData(
            maxY: 12,
            barGroups: stats.barGroups,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (_) => TwonDSColors.surface,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    _formatDuration(rod.toY),
                    TwonDSTextStyles.bodySmall(context).copyWith(color: Colors.white),
                  );
                },
              ),
            ),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                if (myGoalHours == partnerGoalHours)
                  HorizontalLine(
                    y: myGoalHours.toDouble(),
                    color: TwonDSColors.accentMoon.withValues(alpha: 0.4),
                    strokeWidth: 1.5,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      labelResolver: (line) => AppStrings.goalLabel,
                      style: TwonDSTextStyles.bodySmall(context).copyWith(
                        fontSize: 9, 
                        color: TwonDSColors.onSurfaceVariant,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                else ...[
                  HorizontalLine(
                    y: myGoalHours.toDouble(),
                    color: TwonDSColors.accentMoon.withValues(alpha: 0.8),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (line) => AppStrings.myGoalLabel,
                      style: TwonDSTextStyles.bodySmall(context).copyWith(fontSize: 9),
                    ),
                  ),
                  HorizontalLine(
                    y: partnerGoalHours.toDouble(),
                    color: TwonDSColors.accentMoon.withValues(alpha: 0.6),
                    strokeWidth: 1,
                    dashArray: [8, 4],
                    label: HorizontalLineLabel(
                      show: true,
                      labelResolver: (line) => AppStrings.partnerGoalLabel,
                      style: TwonDSTextStyles.bodySmall(context).copyWith(fontSize: 9),
                    ),
                  ),
                ],
              ],
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true, 
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) => Text('${value.toInt()}h', style: TwonDSTextStyles.bodySmall(context).copyWith(fontSize: 9)),
                )
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < stats.allDates.length) {
                      return Text(stats.allDates[index].split('-').last, style: TwonDSTextStyles.bodySmall(context));
                    }
                    return const Text('');
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
          ),
        ),
      ),
    );
  }

  String _formatDuration(double decimalHours) {
    if (decimalHours <= 0) return "0h 0m";
    int hours = decimalHours.toInt();
    int minutes = ((decimalHours - hours) * 60).round();
    if (minutes == 60) { hours++; minutes = 0; }
    return "${hours}h:${minutes.toString().padLeft(2, '0')}m";
  }
}