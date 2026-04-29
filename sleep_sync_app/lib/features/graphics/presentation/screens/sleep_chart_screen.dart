import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/graphics/domain/models/sleep_chart.dart';
import 'package:sleep_sync_app/features/graphics/presentation/chart_providers.dart';
import 'package:sleep_sync_app/features/graphics/presentation/screens/widgets/double_bar_chart.dart';
import 'package:sleep_sync_app/features/graphics/presentation/screens/widgets/mutual_quality_chart.dart';
import 'package:sleep_sync_app/features/link/presentation/linking_provider.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class SleepChartScreen extends ConsumerWidget {
  const SleepChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partner = ref.watch(partnerProvider).value;
    if (partner == null || partner.uid.trim().isEmpty) {
      return _buildNoPartnerState(context);
    }
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    final chartState = ref.watch(sleepChartControllerProvider(partner.uid));
    final String formattedDate = DateFormat('EEEE, d MMMM', 'es_ES').format(DateTime.now());

    return chartState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text("Error: $err")),
      data: (data) {
        final pieStats = ref.read(sleepChartControllerProvider(partner.uid).notifier).pieChartData;
        final barStats = ref.read(sleepChartControllerProvider(partner.uid).notifier).barChartData;
        
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, formattedDate),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTabs(ref, context, data.range, partner.uid),
                    const SizedBox(height: 30),
                    _buildSectionTitle(context, AppStrings.sleepQualityTitle),
                    SizedBox(
                      height: 200,
                      child: MutualQualityPie(
                        stats: pieStats,
                        partnerName: user?.partnerName ?? AppStrings.defaultPartnerName,
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildSectionTitle(context, AppStrings.hoursVsGoalTitle),
                    SizedBox(
                      height: 300,
                      child: DoubleBarChart(
                        stats: barStats,
                        myGoalHours: user?.sleepGoal?.toInt() ?? 8, 
                        partnerGoalHours: partner.sleepGoal?.toInt() ?? 8,
                        partnerName: user?.partnerName ?? AppStrings.defaultPartnerName,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _buildNoPartnerState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_rounded, 
              size: 80, 
              color: TwonDSColors.accentMoon.withValues(alpha: 0.2)
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.noPartnerTitle,
              style: TwonDSTextStyles.h2(context),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.noPartnerDescription,
              style: TwonDSTextStyles.bodyMedium(context).copyWith(
                color: TwonDSColors.onSurfaceVariant
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    }
  }

  Widget _buildHeader(BuildContext context, String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(AppStrings.linkedTitle, style: TwonDSTextStyles.h1(context)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: TwonDSColors.accentMoon.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              formattedDate.toUpperCase(),
              style: TwonDSTextStyles.bodySmall(context).copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabs(WidgetRef ref, BuildContext context, ChartRange currentRange, String partnerId) {
    final List<String> labels = ["Semana", "Mes"];
    final int selectedIndex = currentRange == ChartRange.week ? 0 : 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double tabWidth = constraints.maxWidth / labels.length;

          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment(selectedIndex == 0 ? -1 : 1, 0),
                child: Container(
                  width: tabWidth - 4,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              Row(
                children: List.generate(labels.length, (index) {
                  final bool isSelected = index == selectedIndex;
                  
                  return GestureDetector(
                    onTap: () {
                      final range = index == 0 ? ChartRange.week : ChartRange.month;
                      ref.read(sleepChartControllerProvider(partnerId).notifier).setRange(range);
                    },
                    child: Container(
                      width: tabWidth,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: Text(
                        labels[index],
                        style: TwonDSTextStyles.bodyMedium(context).copyWith(
                          color: isSelected 
                              ? isDark ? TwonDSColors.accentMoon : TwonDSColors.primaryNight
                              : Colors.grey.withValues(alpha: 0.7),
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w100,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(title, style: TwonDSTextStyles.h2(context)),
    );
  }
