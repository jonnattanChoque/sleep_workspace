// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/unlink/presentation/unlinking_provider.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class UnlinkedDashboard extends ConsumerWidget {
  const UnlinkedDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _UnlinkedDashboardContent();
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
      ref.read(unlinkingControllerProvider.notifier).initLinkingFlow()
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
        onFocus: true,
        controller: codeController
      ),
      actionButton: TwonDSElevatedButton(
        text: AppStrings.linkAction,
        onPressed: () async {
          final code = codeController.text.trim();
          
          if (code.isNotEmpty) {
            Navigator.pop(context);
            await ref.read(unlinkingControllerProvider.notifier).linkWithPartner(code);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final linkingState = ref.watch(unlinkingControllerProvider);
    final code = linkingState.valueOrNull;

    ref.listen<AsyncValue>(unlinkingControllerProvider, (previous, next) {
        if (next is AsyncError && previous is! AsyncError) {
          final errorMessage = next.error.toString();
          TwnDSMessage.show(context, errorMessage.toString(), isError: true);
        }
        if (previous is AsyncLoading && next is AsyncData) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
    );
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        Text(AppStrings.linkedTitle, style: TwonDSTextStyles.h1(context)),
        const SizedBox(height: 12),
        Text(
          AppStrings.unlinkedSubtitle, 
          textAlign: TextAlign.center, 
          style: TwonDSTextStyles.bodyMedium(context),
        ),
        const SizedBox(height: 18),
        
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white.withValues(alpha: .03) 
                : Theme.of(context).colorScheme.surface,
            
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08)
            ),
            boxShadow: Theme.of(context).brightness == Brightness.light 
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ]
              : null,
          ),
          child: Column(
            children: [
              Text(
                AppStrings.yourLinkCode, 
                style: TwonDSTextStyles.labelHighlight(context)
              ),
              const SizedBox(height: 20),
              Text(
                code ?? '---',
                style: TwonDSTextStyles.displayCode(context),
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
        
        const SizedBox(height: 25),
        const TwonDSStepRow(number: '1', text: AppStrings.step1),
        const TwonDSStepRow(number: '2', text: AppStrings.step2),
        const TwonDSStepRow(number: '3', text: AppStrings.step3),
        
        const SizedBox(height: 20),
        TwonDSElevatedButton(
          text: AppStrings.haveCodeAction,
          onPressed: () => _showLinkModal(context),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}