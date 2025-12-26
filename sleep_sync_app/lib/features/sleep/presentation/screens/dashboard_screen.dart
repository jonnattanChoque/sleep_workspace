import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/sleep/presentation/screens/unlinked_dashboard_screen.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TwonDSColors.primaryNight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(AppStrings.title, style: TwonDSTextStyles.brandLogoMini),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(TwonDSIcons.logout, color: Colors.white54, size: 20),
                    onPressed: () => _showLogoutDialog(context, ref),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: const [
                    UnlinkedDashboard(),
                    Center(child: Text(AppStrings.tabHistory, style: TextStyle(color: Colors.white))),
                    Center(child: Text(AppStrings.tabProfile, style: TextStyle(color: Colors.white))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: TwonDSColors.primaryNight,
        selectedItemColor: TwonDSColors.accentMoon,
        unselectedItemColor: Colors.white24,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.nights_stay_rounded), label: AppStrings.tabToday),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: AppStrings.tabHistory),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: AppStrings.tabProfile),
        ],
      ),
    );
  }
}