// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_chart_model.dart';
import 'package:sleep_sync_app/features/link/presentation/linking_provider.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';

class LinkedDashboard extends ConsumerWidget {
  const LinkedDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _LinkedDashboardContent();
  }
}

class _LinkedDashboardContent extends ConsumerStatefulWidget {
  const _LinkedDashboardContent();

  @override
  ConsumerState<_LinkedDashboardContent> createState() => _LinkedDashboardContentState();
}

class _LinkedDashboardContentState extends ConsumerState<_LinkedDashboardContent> {
  late AudioPlayer _audioPlayer;

  void _showSleepLogModal(BuildContext context, WidgetRef ref, double sleepGoal) {
    double hoursLogged = sleepGoal;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final isLoading = ref.watch(linkingControllerProvider) is AsyncLoading;

          return PopScope(
            canPop: !isLoading,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
            },
            child: StatefulBuilder(
              builder: (context, setModalState) {
                int calculatedQuality = ref.read(linkingControllerProvider.notifier).calculateQuality(hoursLogged);

                return AbsorbPointer(
                  absorbing: isLoading,
                  child: TwonDSModalLayout(
                    title: AppStrings.registerSleepTitle,
                    children: [
                      Center(
                        child: Text(
                          "${hoursLogged.toStringAsFixed(1)} h",
                          style: TwonDSTextStyles.h1(context).copyWith(
                            color: TwonDSColors.accentMoon,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Slider(
                        value: hoursLogged,
                        min: 0,
                        max: 12,
                        divisions: 24,
                        activeColor: TwonDSColors.accentMoon,
                        onChanged: (val) {
                          setModalState(() => hoursLogged = val);
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final isLit = index < calculatedQuality;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: Icon(
                              isLit ? Icons.star_rounded : Icons.star_outline_rounded,
                              color: isLit ? Colors.amber : Colors.grey.withValues(alpha: 0.3),
                              size: isLit ? 45 : 35,
                            ),
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 10),
                      Text(
                        AppStrings.sleepMessage(calculatedQuality),
                        textAlign: TextAlign.center,
                        style: TwonDSTextStyles.bodySmall(context),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      TwonDSElevatedButton(
                        text: AppStrings.buttonConfirm,
                        onPressed: isLoading ? null : () async {
                          await ref.read(linkingControllerProvider.notifier).saveRecord(hoursLogged);
                          if (context.mounted) Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              }
            )
          );  
        },
      ),
    );
  }

  Future<void> _checkAndShowModal() async {
    try {
      final logs = await ref.read(sleepLogsProvider.future);
      if (!mounted) return;

      final alreadyLogged = ref.read(linkingControllerProvider.notifier).hasRecordForToday(logs);

      if (!alreadyLogged && mounted) {
        _showSleepLogModal(context, ref, 0);
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowModal();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, d MMMM', 'es_ES').format(DateTime.now());
    final sleepLogsAsync = ref.watch(sleepLogsProvider);
    final partner = ref.watch(partnerProvider).value;
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    if (user == null) return const SizedBox.shrink();
    
    ref.listen<AsyncValue>(linkingControllerProvider, (previous, next) {
      if (previous?.isLoading == true && !next.isLoading && !next.hasError) {
        final message = next.value;
        
        if (message != null && message.isNotEmpty) {
          TwnDSMessage.show(context, message, isError: false);
        }
      }

      if (next.hasError && !next.isLoading) {
        final message = next.value;
        TwnDSMessage.show(
          context, message,
          isError: true,
        );
      }
    });

    final myStats = ref.watch(sleepChartPresenterProvider(user.uid));
    final partnerStats = ref.watch(sleepChartPresenterProvider(partner?.uid ?? ""));

    return sleepLogsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (logs) {

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(formattedDate),
            const SizedBox(height: 18),
            _buildMyRegistrationNudge(myStats),
            const SizedBox(height: 18),
            _buildDualSleepCharts(user, partner, myStats, partnerStats),
            const SizedBox(height: 18),
            _buildPushPartnet(partnerStats, partner),
            const SizedBox(height: 18),
            _buildMetricsGrid()
          ],
        );
      },
    );
  }

  Widget _buildHeader(String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Text(AppStrings.linkedTitle, style: TwonDSTextStyles.h1(context)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3,
              height: 14,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
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

  Widget _buildMyRegistrationNudge(AsyncValue<SleepChartState> stats) {
    return stats.maybeWhen(
      data: (data) => data.hours == 0 
          ? TwonDSBanner(
              text: AppStrings.linkRecordTitle,
              actionLabel: AppStrings.linkRecordButton,
              onTap: () => _showSleepLogModal(context, ref, 8),
            ) 
          : const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      orElse: () => const SizedBox.shrink(),
    );
  }
  
  Widget _buildDualSleepCharts(
    AppUser user, 
    AppUser? partner, 
    AsyncValue<SleepChartState> myTodayStats, 
    AsyncValue<SleepChartState> partnerTodayStats
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        myTodayStats.maybeWhen(
          data: (myData) => TwonDSRadialChart(
              label: "Tú: ${myData.hours == 0.0 ? 0 : myData.hours} h",
              progress: myData.progress == 0.0 ? 99 : myData.progress,
              lottiePath: myData.lottiePath,
              color: myData.chartColor, 
              onTap: () => _showTooltip(
                context, 
                myData.progress, 
                "${user.name} hoy dormiste ${myData.hours == 0.0 ? 0 : myData.hours} horas, lo que corresponde al ${myData.percent}% de tu meta",
              ),
            ),
          orElse: () => const CircularProgressIndicator(),
        ),
        partnerTodayStats.maybeWhen(
          data: (pData) => TwonDSRadialChart(
            label: "${partner?.name}: ${pData.hours == 0.0 ? 0 : pData.hours} h",
            progress: pData.progress == 0.0 ? 99 : pData.progress,
            lottiePath: pData.lottiePath,
            color: pData.chartColor, 
            onTap: () => _showTooltip(
              context, 
              pData.progress, 
              "${partner?.name} hoy durmió ${pData.hours == 0.0 ? 0 : pData.hours} horas, lo que corresponde al ${pData.percent}% de su meta",
            ),
          ),
          orElse: () => const CircularProgressIndicator(),
        ),
      ],
    );
  }

  Widget _buildPushPartnet(AsyncValue<SleepChartState> partnerTodayStats, AppUser? partner) {
    return partnerTodayStats.maybeWhen(
      data: (data) => data.hours == 0
        ? TwonDSUserHeader(
            name: "${partner?.name} ${AppStrings.linkPartnerRecordTitle}", 
            email: AppStrings.linkPartnerRecordMessage,
            avatar: IconButton.filledTonal(
              icon: const Icon(Icons.vibration),
              onPressed: () async {
                await _audioPlayer.play(AssetSource('sounds/send.mp3'));
                HapticFeedback.vibrate();
                _sendNudge();
                TwnDSMessage.show(context, "${AppStrings.linkPartnerRecorsend} ${partner?.name}", isError: false);
              },
            )
          )
        : const SizedBox.shrink(),
      loading: () => const CircularProgressIndicator(),
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TwonDSStatCard(
                  title: AppStrings.streakTitle,
                  value: "${6} ${AppStrings.days}",
                  valueColor: const Color.fromARGB(255, 223, 85, 61),
                  height: 150,
                  centerIcon: Icons.local_fire_department,
                  iconTap: TwonDSIcons.edit,
                  onTap: () {}
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: TwonDSStatCard(
                  title: AppStrings.sleepDiff,
                  value: "7 h",
                  valueColor: const Color.fromARGB(255, 161, 159, 162),
                  centerIcon: TwonDSIcons.minus,
                  height: 150,
                  onTap: () {}
                ),
              ),
            ],
          ),
        ],
      );
  }

  void _showTooltip(BuildContext context, double progress, label) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  void _sendNudge() { }
}