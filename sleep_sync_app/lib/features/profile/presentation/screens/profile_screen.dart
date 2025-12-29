// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

  void _openSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TwonDSModalLayout(
        title: AppStrings.profileConfiguration,
        children: [
          TwonDSModalTile(
            icon: Icons.person_outline,
            title: AppStrings.profileEditProfile,
            onTap: () {},
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
            value: true,
            onChanged: (val) {},
          ),
          const Divider(color: Colors.white10),
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
        _buildIdentityCard(),
        const SizedBox(height: 30),
        _buildMetricsGrid(),
        const SizedBox(height: 20),
        _buildActionItem(
          Icons.security_outlined, 
          AppStrings.profileConfiguration,
          () {
            _openSettings(context);
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

  Widget _buildIdentityCard() {
    return TwonDSUserHeader(
      name: "", 
      email: "",
      avatar: TwonDSAvatar(
        imageUrl: "",
        radius: 30,
        backgroundColor: Colors.grey[200], 
        iconColor: Colors.grey,
      ),
      bottomChild: const TwonDSBadge(
        text: "",
        icon: TwonDSIcons.link,
        color: TwonDSColors.partnerColor,
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