import 'package:fl_chart/fl_chart.dart';

class BarChartState {
  final List<String> allDates;
  final List<BarChartGroupData> barGroups;
  final double calculatedWidth;

  BarChartState({
    required this.allDates,
    required this.barGroups,
    required this.calculatedWidth,
  });

  factory BarChartState.empty() => BarChartState(
    allDates: [],
    barGroups: [],
    calculatedWidth: 0,
  );
}