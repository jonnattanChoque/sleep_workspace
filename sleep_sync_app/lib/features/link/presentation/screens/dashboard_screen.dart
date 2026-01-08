import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:sleep_sync_app/features/link/presentation/screens/linked_dashboard_screen.dart';
import 'package:sleep_sync_app/features/unlink/presentation/screens/unlinked_dashboard_screen.dart';
import 'package:sleep_ui_kit/sleep_ui_kit.dart';


final dashboardIndexProvider = StateProvider<int>((ref) => 0);

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    int selectedIndex = ref.watch(dashboardIndexProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: innerBoxIsScrolled 
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).colorScheme.surface,
              pinned: true,
              expandedHeight: 90,
              automaticallyImplyLeading: false,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  color: innerBoxIsScrolled 
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                centerTitle: false,
                titlePadding: EdgeInsets.zero,
                title: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.title,
                          style: TwonDSTextStyles.brandLogoMini(context),
                        ),
                        const SizedBox(width: 5),
                        Icon(TwonDSIcons.logoHeader, size: 15, color: Theme.of(context).colorScheme.primary),
                        const Spacer(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              icon: Icon(
                                TwonDSIcons.logout,
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), 
                                size: 18
                              ),
                              onPressed: () => _showLogoutDialog(context, ref),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: _buildCurrentTab(selectedIndex, user, ref),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index != selectedIndex) {
            setState(() {
              ref.read(dashboardIndexProvider.notifier).state = index;
            });
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(0);
            }
          }
        },
        
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.24),
        
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

  Widget _buildCurrentTab(int index, AppUser user, WidgetRef ref) {
    switch (index) {
      case 0:
        return SizedBox(
          key: const ValueKey('tab_today'),
          child: _getTodayTabContent(user, ref),
        );
      case 1:
        return const SizedBox(
          key: ValueKey('tab_history'),
          child: Center(
            child: Text(
              AppStrings.tabHistory, 
              style: TextStyle(color: Colors.white)
            ),
          ),
        );
      case 2:
        return ProfileScreen(
          key: const ValueKey('tab_profile'),
          user: user,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getTodayTabContent(AppUser user, WidgetRef ref) {
    final hasPartner = user.partnerId != null && user.partnerId!.trim().isNotEmpty;

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
      },
      color: TwonDSColors.accentMoon,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: hasPartner 
                  ? const LinkedDashboard() 
                  : const UnlinkedDashboard(),
            ),
          ),
        ],
      )
    );
  }
}