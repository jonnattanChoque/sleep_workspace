// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: use_build_context_synchronously
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/core/provider/theme_provider.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/link/presentation/linking_provider.dart';
import 'package:sleep_sync_app/features/unlink/presentation/unlinking_provider.dart';
import 'package:sleep_sync_app/features/profile/domain/enum/profile_failure.dart';
import 'package:sleep_sync_app/features/profile/presentation/profile_provider.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class ProfileScreen extends ConsumerWidget {
  final AppUser user;
  const ProfileScreen({super.key, required this.user});

  void _openSettings(BuildContext context, WidgetRef ref, AppUser user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer( 
        builder: (context, ref, child) {
            return TwonDSModalLayout(
              title: AppStrings.profileConfiguration,
              children: [
                TwonDSModalTile(
                  icon: Icons.person_outline,
                  title: AppStrings.profileEditProfile,
                  iconTab: TwonDSIcons.edit,
                  onTap: () async {
                    Navigator.pop(context);
                    
                    final TextEditingController nameController = TextEditingController(text: user.name);
                    TwnDSInputDialogModal.show(
                      context: context, 
                      title: AppStrings.profileEditProfile, 
                      description: AppStrings.editProfileSubtitle, 
                      inputField: TwonDSTextField(
                        onFocus: true,
                        hint: AppStrings.nameTextield, 
                        icon: TwonDSIcons.profile, 
                        controller: nameController
                      ),
                      actionButton: Consumer(
                        builder: (context, ref, child) {
                          final profileState = ref.watch(profileControllerProvider);
                          final bool isLoading = profileState.isLoading;
                          
                          return PopScope(
                            canPop: !isLoading,
                            child: TwonDSElevatedButton(
                              text: AppStrings.editProfileButton,
                              isLoading: isLoading, 
                              onPressed: isLoading 
                                ? null
                                : () async {
                                    final newName = nameController.text.trim();
                                    final success = await ref.read(profileControllerProvider.notifier).updateName(newName);
                                    if (!context.mounted) return;
                            
                                    if (success && context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                            ),
                          );
                        },
                      ),
                    );
                  }
                ),
                TwonDSSwitchTile(
                  icon: Icons.notifications_none,
                  title: AppStrings.profilePush,
                  value: ref.watch(notificationsSwitchProvider),
                  onChanged: (bool isOn) async {
                    ref.read(notificationsSwitchProvider.notifier).state = isOn;
                    await ref.read(profileControllerProvider.notifier).togglePush(isOn);
                    if (!context.mounted) return;

                    await Future.delayed(const Duration(milliseconds: 500));
                    Navigator.pop(context);
                  },
                ),
                TwonDSSwitchTile(
                  icon: Icons.dark_mode_outlined,
                  title: AppStrings.profileTheme,
                  value: ref.watch(themeModeProvider) == ThemeMode.dark,
                  onChanged: (bool isDarkMode) async {
                    final themeLoading = ref.read(themeLoadingProvider.notifier);
                    final themeMode = ref.read(themeModeProvider.notifier);
                    final storage = ref.read(storageServiceProvider);
                    
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 250));

                    themeLoading.state = true;
                    await Future.delayed(const Duration(milliseconds: 800));

                    themeMode.state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
                    await storage.setThemeMode(isDarkMode);
                    await Future.delayed(const Duration(milliseconds: 1200));
                    
                    themeLoading.state = false;
                  },
                ),
                Divider(color: Theme.of(context).dividerColor),
                TwonDSModalTile(
                  icon: Icons.logout,
                  title: AppStrings.profileLogout,
                  color: Colors.redAccent,
                  onTap: () => _showLogoutDialog(context, ref),
                ),
              ],
            );
        }
      )
    );
  }
  
  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => TwnDSConfirmDialog(
        title: AppStrings.confirmTitle,
        description: AppStrings.confirmMessage,
        confirmText: AppStrings.confirmAction,
        onConfirm: () async {
          await ref.read(authControllerProvider.notifier).signOut();
          if (context.mounted) Navigator.pop(context);
        },
      ),
    );
  }
  
  void _showLinkModal(BuildContext context, WidgetRef ref) {
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
  
  void _showSleepGoalPicker(BuildContext context, WidgetRef ref, double currentGoal) {
    final List<double> options = List.generate(17, (index) => 4.0 + (index * 0.5));
    int initialItem = options.indexOf(currentGoal);
    if (initialItem == -1) initialItem = 8;
    double selectedGoal = currentGoal;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return TwonDSModalLayout(
            title: AppStrings.sleepGoalTitle,
            children: [
              SizedBox(
                height: 200,
                child: CupertinoPicker(
                  scrollController: FixedExtentScrollController(initialItem: initialItem),
                  itemExtent: 40,
                  onSelectedItemChanged: (index) {
                    selectedGoal = options[index];
                  },
                  children: options.map((h) => Center(
                    child: Text("$h${AppStrings.hours}", style: TwonDSTextStyles.bodyMedium(context)),
                  )).toList(),
                ),
              ),
              const SizedBox(height: 20),
              TwonDSElevatedButton(
                text: AppStrings.buttonConfirm,
                onPressed: () {
                  ref.read(profileControllerProvider.notifier).updateSleepGoal(selectedGoal);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<AsyncValue>(unlinkingControllerProvider, (previous, next) {
      if (previous is AsyncLoading && !next.isLoading) {
        final actionState = next.value;
        if (actionState!.message.isNotEmpty) {
          TwnDSMessage.show(
            context, 
            actionState.message, 
            isError: actionState.isError,
          );
        }
      }
    });

    ref.listen<AsyncValue<ProfileActionState>>(profileControllerProvider, (previous, next) {
      if (previous is AsyncLoading && next is AsyncData) {
        final actionState = next.value;
        
        if (actionState!.message.isNotEmpty) {
          TwnDSMessage.show(
            context, 
            actionState.message, 
            isError: actionState.isError,
          );
        }
      }
    });

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildIdentityCard(user),
          const SizedBox(height: 30),
          _buildMetricsGrid(context, ref),
          const SizedBox(height: 50),
          _showlinkedButton(context, ref, user),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(AppUser userApp) {
    final isLinked = userApp.partnerName.toString().isNotEmpty && userApp.partnerName != null;

    return TwonDSUserHeader(
      name: userApp.name ?? "", 
      email: userApp.email,
      avatar: const TwonDSAvatar(
        imageUrl: "",
        radius: 30,
      ),
      bottomChild: TwonDSBadge(
        text: isLinked ? userApp.partnerName ?? "" : AppStrings.noLinkend,
        icon: TwonDSIcons.link,
        customColor: isLinked ? null : Colors.grey.withValues(alpha: 0.7),
      )
    );
  }

  Widget _buildMetricsGrid(BuildContext context, WidgetRef ref) {
    final myStats = user.stats;
    final String myAvgValue = "${myStats.avgHours.toStringAsFixed(1)}h";

    final partner = ref.watch(partnerProvider).value;
    final String partnerAvgValue = "${partner?.stats.avgHours.toStringAsFixed(1)}h";

    String linkAvgValue = "--";
    if (partner != null) {
      final totalH = myStats.totalHours + partner.stats.totalHours;
      final totalR = myStats.totalRecords + partner.stats.totalRecords;
      linkAvgValue = totalR > 0 ? "${(totalH / totalR).toStringAsFixed(1)}h" : "0.0h";
    }

    return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TwonDSStatCard(
                  title: AppStrings.profileGoalTitle,
                  value: "${user.sleepGoal}h",
                  valueColor: TwonDSColors.secondText,
                  height: 130,
                  centerIcon: Icons.alarm_on_rounded,
                  iconTap: TwonDSIcons.edit,
                  onTap: () => _showSleepGoalPicker(context, ref, user.sleepGoal ?? 0)
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: TwonDSStatCard(
                  title: AppStrings.editProfileButton,
                  value: AppStrings.profileConfiguration,
                  valueColor: TwonDSColors.secondText,
                  centerIcon: Icons.security,
                  height: 130,
                  onTap: () => _openSettings(context, ref, user)
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TwonDSStatCard(
                  title: AppStrings.profileAverageSleep,
                  value: myAvgValue,
                  valueColor: TwonDSColors.secondText,
                  iconTap: TwonDSIcons.eye,
                  centerIcon: TwonDSIcons.onePerson,
                  height: 150,
                  onTap: () {},
                )
                
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: TwonDSStatCard(
                  title: AppStrings.togetherAverageSleep,
                  value: "$linkAvgValue -- $partnerAvgValue",
                  valueColor: TwonDSColors.secondText,
                  iconTap: TwonDSIcons.eye,
                  centerIcon: TwonDSIcons.twoPerson,
                  height: 150,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      );
  }

  Widget _showlinkedButton(BuildContext context, WidgetRef ref, AppUser user) {
    final isLinked = user.partnerName.toString().isNotEmpty && user.partnerName != null;

    if (isLinked) {
      return TwonDSActionSlider(
        label: AppStrings.profileSliderUnlink,
        placeholder: AppStrings.profileSliderPlaceholder,
        onAction: () {
          ref.read(profileControllerProvider.notifier).unlink();
        },
      );
    } else {
      return TwonDSElevatedButton(
        text: AppStrings.linkPartnerTitle,
        onPressed: () => _showLinkModal(context, ref),
      );
    }
  }
}

final notificationsSwitchProvider = StateProvider<bool>((ref) => false);