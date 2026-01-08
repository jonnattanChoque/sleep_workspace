// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/link/domain/models/sleep_record_model.dart';
import 'package:sleep_sync_app/features/link/presentation/linking_provider.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

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
  ConsumerState<_LinkedDashboardContent> createState() => _UnlinkedDashboardContentState();
}

class _UnlinkedDashboardContentState extends ConsumerState<_LinkedDashboardContent> {
  
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
    final sleepLogsAsync = ref.read(sleepLogsProvider);
    sleepLogsAsync.whenData((logs) {
      final now = DateTime.now();
      final String todayId = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      final bool alreadyLoggedToday = logs.any((record) => record.id == todayId);

      if (!alreadyLoggedToday && mounted) {
        _showSleepLogModal(context, ref, 0.0);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowModal();
    });
    
  }

  @override
  Widget build(BuildContext context) {

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
    
    final sleepLogsAsync = ref.watch(sleepLogsProvider);

    bool _checkIfLoggedToday(List<SleepRecord> logs) {
      final now = DateTime.now();
      final todayId = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
      return logs.any((record) => record.id == todayId);
    }

    return sleepLogsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (logs) {
        final isLoggedToday = _checkIfLoggedToday(logs);
        return Column(
          children: [
            if (!isLoggedToday)
              TwonDSElevatedButton(text: "text", onPressed: () {
                _showSleepLogModal(context, ref, 0);
              }),
              const SizedBox(height: 20), 
          ],
        );
      },
    );
  }
}