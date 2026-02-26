// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:sleep_sync_app/core/constants/app_strings.dart';
import 'package:sleep_sync_app/core/helper/product_tour_style.dart';
import 'package:sleep_sync_app/core/services/storage_service.dart';
import 'package:sleep_sync_app/features/auth/domain/models/app_user.dart';
import 'package:sleep_sync_app/features/auth/presentation/auth_providers.dart';
import 'package:sleep_sync_app/features/link/presentation/dashboard_provider.dart';
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
  bool _tourLauncher = false;
  final GlobalKey _keyTabToday = GlobalKey();
  final GlobalKey _keyTabHistory = GlobalKey();
  final GlobalKey _keyTabProfile = GlobalKey();
  final GlobalKey _keyCardCodigo = GlobalKey();
  final GlobalKey _keyBotonVincular = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkTourStatus();
      ref.read(dashboardControllerProvider.notifier).syncFeatures();
    });
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _checkTourStatus() async {
    final storage = StorageService();
    final isCompleted = await storage.isTourCompleted(AppTour.dashboard.name);
    
    if (!isCompleted) {
      setState(() {
        _tourLauncher = false;
      });
    } else {
      setState(() {
        _tourLauncher = true;
      });
    }
  }

  void _startTour(BuildContext showcaseContext) {
    if (_tourLauncher) return;
    
    _tourLauncher = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;

      final historyActive = ref.read(dashboardControllerProvider);
      final List<GlobalKey> steps = [
        _keyTabToday,
        if (historyActive) _keyTabHistory,
        _keyTabProfile,
        _keyCardCodigo,
        _keyBotonVincular,
      ];
      
      ShowCaseWidget.of(showcaseContext).startShowCase(steps);
    });
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
    final isHistoryEnabled = ref.watch(dashboardControllerProvider);
    int selectedIndex = ref.watch(dashboardIndexProvider);
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    ref.listen(externalLogoutRequestProvider, (previous, next) {
      if (next == true) {
        ref.read(externalLogoutRequestProvider.notifier).state = false;
        _showLogoutDialog(context, ref);
      }
    });

    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  
    return ShowCaseWidget(
      blurValue: 1,
      autoPlay: false,
      onFinish: () async {
        await StorageService().setTourCompleted(AppTour.dashboard.name);
      },
      builder: (context) => Builder(
        builder: (showcaseContext) {

          if (!_tourLauncher) {
            _startTour(showcaseContext);
          }
          return _buildDashboardContent(context, selectedIndex, user, isHistoryEnabled);
        }
      ),
    );
  }

  Scaffold _buildDashboardContent(BuildContext context, int selectedIndex, AppUser user, bool isHistoryEnabled) {
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
          child: _buildCurrentTab(selectedIndex, user, ref, isHistoryEnabled),
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
        items: [
          BottomNavigationBarItem(
            icon: SleepShowcase(
              showcaseKey: _keyTabToday,
              title: AppStrings.tourDashboardTodayTitle,
              description: AppStrings.tourDashboardTodayDesc,
              child: const Icon(Icons.nights_stay_rounded),
            ),
            label: AppStrings.tabToday,
          ),
          if (isHistoryEnabled)
            BottomNavigationBarItem(
              icon: SleepShowcase(
                showcaseKey: _keyTabHistory,
                title: AppStrings.tourDashboardHistoryTitle,
                description: AppStrings.tourDashboardHistoryDesc,
                child: const Icon(Icons.bar_chart_rounded),
              ),
              label: AppStrings.tabHistory,
            ),
          BottomNavigationBarItem(
            icon: SleepShowcase(
              showcaseKey: _keyTabProfile,
              title: AppStrings.tourDashboardProfileTitle,
              description: AppStrings.tourDashboardProfileDesc,
              child: const Icon(Icons.person_outline_rounded),
            ),
            label: AppStrings.tabProfile,
          )
        ],
      ),
    );
  }

  Widget _buildCurrentTab(int index, AppUser user, WidgetRef ref, bool ishistoryEnabled) {
    int effectiveIndex = index;
    if (!ishistoryEnabled && index == 1) {
      effectiveIndex = 2;
    }
    
    switch (effectiveIndex) {
      case 0:
        return SizedBox(key: const ValueKey('tab_today'), child: _getTodayTabContent(user, ref));
      case 1:
        return const SizedBox(
          key: ValueKey('tab_history'),
          child: Center(child: Text(AppStrings.tabHistory, style: TextStyle(color: Colors.white))),
        );
      case 2:
        return const ProfileScreen(key: ValueKey('tab_profile'));
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
                  : UnlinkedDashboard(
                    keyCard: _keyCardCodigo,
                    keyButton: _keyBotonVincular,
                  ),
            ),
          ),
        ],
      )
    );
  }
}