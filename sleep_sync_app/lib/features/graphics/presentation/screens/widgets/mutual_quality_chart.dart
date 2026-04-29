import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/chart_pie.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class MutualQualityPie extends StatelessWidget {
  final PieChartState stats;
  final String partnerName;

  const MutualQualityPie({required this.stats, required this.partnerName});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 60,
            sections: [
              PieChartSectionData(
                value: stats.myShare,
                color: TwonDSColors.success,
                title: '${AppStrings.meLabel}\n${stats.myShare.toInt()}%',
                showTitle: true,
                radius: 50,
                titleStyle: TwonDSTextStyles.bodySmall(context).copyWith(color: Colors.white),
              ),
              PieChartSectionData(
                value: stats.partnerShare,
                color: TwonDSColors.secondText,
                title: '$partnerName\n${stats.partnerShare.toInt()}%',
                showTitle: true,
                radius: 50,
                titleStyle: TwonDSTextStyles.bodySmall(context).copyWith(color: Colors.white),
              ),
              PieChartSectionData(
                value: stats.greyArea,
                color: Colors.grey.withValues(alpha: 0.1),
                title: '',
                radius: 40,
              ),
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${stats.totalPercent}%", style: TwonDSTextStyles.h1(context)),
            Text("${stats.avgStars.toStringAsFixed(1)} ⭐", style: TwonDSTextStyles.bodySmall(context)),
          ],
        ),
      ],
    );
  }
}