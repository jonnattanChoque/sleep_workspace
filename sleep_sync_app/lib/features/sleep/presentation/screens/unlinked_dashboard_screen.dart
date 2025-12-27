// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/linking/presentation/linking_provider.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class UnlinkedDashboard extends ConsumerWidget {
  const UnlinkedDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: const IntrinsicHeight(
            child: _UnlinkedDashboardContent(),
          ),
        );
      },
    );
  }
}

class _UnlinkedDashboardContent extends ConsumerStatefulWidget {
  const _UnlinkedDashboardContent();

  @override
  ConsumerState<_UnlinkedDashboardContent> createState() => _UnlinkedDashboardContentState();
}

class _UnlinkedDashboardContentState extends ConsumerState<_UnlinkedDashboardContent> {
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      ref.read(linkingControllerProvider.notifier).initLinkingFlow()
    );
  }

  void _showLinkModal(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    TwnDSInputDialogModal.show(
      context: context,
      title: AppStrings.linkPartnerTitle,
      description: AppStrings.linkPartnerSubtitle,
      inputField: TwonDSTextField(
        hint: AppStrings.enterLinkCodeHint, 
        icon: TwonDSIcons.link, 
        controller: codeController
      ),
      actionButton: TwonDSElevatedButton(
        text: AppStrings.linkAction,
        onPressed: () async {
          final code = codeController.text.trim();
          
          if (code.isNotEmpty) {
            Navigator.pop(context);
            await ref.read(linkingControllerProvider.notifier).linkWithPartner(code);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkingState = ref.watch(linkingControllerProvider);
    final code = linkingState.valueOrNull;
    final isLoading = linkingState.isLoading;

    ref.listen<AsyncValue>(linkingControllerProvider, (previous, next) {
        if (next is AsyncError && previous is! AsyncError) {
          final errorMessage = next.error.toString();
          
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage), 
              backgroundColor: TwonDSColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
              margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            ),
          );
        }
        if (previous is AsyncLoading && next is AsyncData) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
    );
    
    return Column(
      children: [
        const Icon(TwonDSIcons.logoHeader, size: 70, color: TwonDSColors.accentMoon),
        const SizedBox(height: 10),
        const Text(AppStrings.unlinkedTitle, style: TwonDSTextStyles.h1),
        const SizedBox(height: 12),
        const Text(
          AppStrings.unlinkedSubtitle, 
          textAlign: TextAlign.center, 
          style: TwonDSTextStyles.bodyMedium,
        ),
        const SizedBox(height: 18),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .03),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)), 
          ),
          child: Column(
            children: [
              const Text(
                AppStrings.yourLinkCode, 
                style: TwonDSTextStyles.labelHighlight),
              const SizedBox(height: 20),
              if (isLoading)
                Column(
                  children: [
                    const CircularProgressIndicator(color: TwonDSColors.accentMoon),
                    const SizedBox(height: 10),
                    Text(
                      AppStrings.creatingCode,
                      style: TwonDSTextStyles.bodySmall.copyWith(color: TwonDSColors.accentMoon),
                    ),
                  ],
                )
              else
                Text(
                  code ?? '---',
                  style: TwonDSTextStyles.displayCode,
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TwonDSActionButton(
                    icon: TwonDSIcons.copy, 
                    label: AppStrings.copy, 
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: code ?? "")).then((_) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: TwonDSColors.success,
                            content: Text(AppStrings.copiedCode),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      });
                    }
                  ),
                  const SizedBox(width: 32),
                  TwonDSActionButton(
                    icon: TwonDSIcons.share,
                    label: AppStrings.share,
                    onTap: () {
                      final String shareText = "${AppStrings.shareCodeMessage} $code";
                      SharePlus.instance.share(ShareParams(text: shareText));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        
        const SizedBox(height: 18),
        
        const TwonDSStepRow(number: '1', text: AppStrings.step1),
        const TwonDSStepRow(number: '2', text: AppStrings.step2),
        const TwonDSStepRow(number: '3', text: AppStrings.step3),
        
        const Spacer(),
        
        TwonDSElevatedButton(
          text: AppStrings.haveCodeAction,
          onPressed: () {
            _showLinkModal(context);
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}