// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class UnlinkedDashboard extends StatelessWidget {
  const UnlinkedDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const IntrinsicHeight(
              child: _unlinkedDashboardContent(),
            ),
          ),
        );
      },
    );
  }
}

class _unlinkedDashboardContent extends StatelessWidget {
  const _unlinkedDashboardContent();

  @override
  Widget build(BuildContext context) {
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
              const Text(
                'SSJC-8X2K',
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
                      Clipboard.setData(const ClipboardData(text: "SSJC-8X2K")).then((_) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
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
                      const String shareText = AppStrings.shareCodeMessage;
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
            // Aquí abriremos el modal para vincular
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}