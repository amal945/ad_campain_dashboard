import 'package:ad_campaign_dashboard/core/config/dependency_injection.dart';
import 'package:ad_campaign_dashboard/core/theme/app_theme.dart';
import 'package:ad_campaign_dashboard/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  runApp(const AdCampaignDashboardApp());
}

class AdCampaignDashboardApp extends StatelessWidget {
  const AdCampaignDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.router;
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          title: 'Ad Campaign Dashboard',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.dark,
          routerConfig: router,
        );
      },
    );
  }
}
