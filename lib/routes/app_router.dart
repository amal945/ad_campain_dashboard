import 'package:ad_campaign_dashboard/core/config/dependency_injection.dart';
import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/features/alerts/provider/alerts_provider.dart';
import 'package:ad_campaign_dashboard/features/alerts/screen/alerts_screen.dart';
import 'package:ad_campaign_dashboard/features/campaigns/provider/campaign_detail_provider.dart';
import 'package:ad_campaign_dashboard/features/campaigns/provider/campaign_list_provider.dart';
import 'package:ad_campaign_dashboard/features/campaigns/screen/campaign_detail_screen.dart';
import 'package:ad_campaign_dashboard/features/campaigns/screen/campaign_list_screen.dart';
import 'package:ad_campaign_dashboard/features/dashboard/provider/dashboard_provider.dart';
import 'package:ad_campaign_dashboard/features/dashboard/screen/dashboard_screen.dart';
import 'package:ad_campaign_dashboard/features/splash/screen/splash_screen.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:ad_campaign_dashboard/routes/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

abstract final class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutePaths.splash,
    routes: <RouteBase>[
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return _BottomShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.campaigns,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: ChangeNotifierProvider<CampaignListProvider>(
                    create: (_) => getIt<CampaignListProvider>()..loadCampaigns(),
                    child: const CampaignListScreen(),
                  ),
                ),
                routes: <RouteBase>[
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final campaignId = state.pathParameters['id'] ?? '';
                      return ChangeNotifierProvider<CampaignDetailProvider>(
                        create: (_) => getIt<CampaignDetailProvider>()..load(campaignId),
                        child: CampaignDetailScreen(campaignId: campaignId),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.spendSummary,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: ChangeNotifierProvider<DashboardProvider>(
                    create: (_) => getIt<DashboardProvider>()..loadSummary(days: 7),
                    child: const DashboardScreen(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.alerts,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: ChangeNotifierProvider<AlertsProvider>(
                    create: (_) => getIt<AlertsProvider>()..startPolling(),
                    child: const AlertsScreen(),
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: RoutePaths.profile,
                pageBuilder: (context, state) => NoTransitionPage(
                  child: Scaffold(
                    appBar: AppBar(title: const Text('Profile')),
                    body: const Center(child: Text('Profile coming soon')),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _BottomShell extends StatelessWidget {
  const _BottomShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.cardBorder)),
          color: AppColors.surface,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 13,
          unselectedFontSize: 12,
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => navigationShell.goBranch(index),
          items: [
            BottomNavigationBarItem(
              icon: Assets.icons.campaignNavIcon.svg(colorFilter: _inactiveFilter),
              activeIcon: Assets.icons.campaignNavIcon.svg(colorFilter: _activeFilter),
              label: 'Campaigns',
            ),
            BottomNavigationBarItem(
              icon: Assets.icons.spendSummaryNavIcon.svg(colorFilter: _inactiveFilter),
              activeIcon: Assets.icons.spendSummaryNavIcon.svg(colorFilter: _activeFilter),
              label: 'Spend Summary',
            ),
            BottomNavigationBarItem(
              icon: Assets.icons.bellIcon.svg(colorFilter: _inactiveFilter),
              activeIcon: Assets.icons.bellIcon.svg(colorFilter: _activeFilter),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Assets.icons.userIcon.svg(colorFilter: _inactiveFilter),
              activeIcon: Assets.icons.userIcon.svg(colorFilter: _activeFilter),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

const _activeFilter = ColorFilter.mode(AppColors.accent, BlendMode.srcIn);
const _inactiveFilter = ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn);
