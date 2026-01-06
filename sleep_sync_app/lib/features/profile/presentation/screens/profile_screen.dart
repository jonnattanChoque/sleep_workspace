// ignore_for_file: no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/core/provider/theme_provider.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/profile/presentation/profile_provider.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class ProfileScreen extends ConsumerWidget {
  final AppUser user;
  const ProfileScreen({super.key, required this.user});
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen<AsyncValue>(profileControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          TwnDSMessage.show(context, error.toString(), isError: true);
        },
        data: (_) {
          if (previous is AsyncLoading) {
            TwnDSMessage.show(context, "Nombre actualizado", isError: false);
          }
        },
      );
    });

    void _openSettings(BuildContext context, WidgetRef ref, AppUser user) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,

        builder: (context) => TwonDSModalLayout(
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
              value: true,
              onChanged: (val) {},
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
              onTap: () {},
            ),
          ],
        ),
      );
    }
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          _buildIdentityCard(user),
          const SizedBox(height: 30),
          _buildMetricsGrid(),
          const SizedBox(height: 20),
          _buildActionItem(
            Icons.security_outlined, 
            AppStrings.profileConfiguration,
            () {
              _openSettings(context, ref, user);
            }
          ),
          const SizedBox(height: 50),
          TwonDSActionSlider(
            label: AppStrings.profileSliderUnlink,
            placeholder: AppStrings.profileSliderPlaceholder,
            onAction: () {},
          ),
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

  Widget _buildMetricsGrid() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
        flex: 3,
        child: TwonDSStatCard(
          title: AppStrings.profileAverageSleep,
          value: "8h 30m",
          valueColor: const Color(0xFF3F51B5),
          height: 160,
          iconTap: TwonDSIcons.edit,
          onTap: () {},
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        flex: 2,
        child: TwonDSStatCard(
          title: AppStrings.profileAverageSleep,
          value: "7.5h",
          height: 120,
          onTap: () {},
        ),
      ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String title,VoidCallback onTap) {
    return TwonDSActionTile(
      icon: icon,
      title: title,
      onTap: onTap,
      iconTap: TwonDSIcons.edit,
    );
  }
}