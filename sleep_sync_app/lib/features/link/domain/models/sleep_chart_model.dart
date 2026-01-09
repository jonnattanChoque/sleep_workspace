import 'package:flutter/material.dart';

class SleepChartState {
  final double progress;
  final String lottiePath;
  final Color chartColor;
  final double hours;
  final String percent;

  SleepChartState({
    required this.progress,
    required this.lottiePath,
    required this.chartColor,
    required this.hours,
    required this.percent,
  });
}