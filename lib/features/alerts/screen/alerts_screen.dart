import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/core/widgets/app_surface_card.dart';
import 'package:ad_campaign_dashboard/core/widgets/async_state_view.dart';
import 'package:ad_campaign_dashboard/core/widgets/pulse_loader.dart';
import 'package:ad_campaign_dashboard/features/alerts/provider/alerts_provider.dart';
import 'package:ad_campaign_dashboard/features/alerts/widget/anomaly_card.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  void dispose() {
    context.read<AlertsProvider>().stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlertsProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: EdgeInsets.all(3.2.w),
              child: Assets.icons.menuIcon.svg(
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            title: Text('Anomaly Alerts', style: AppTextStyles.title),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: RefreshIndicator(
              onRefresh: provider.fetch,
              child: switch (provider.state) {
                ViewState.loading => _buildRefreshableState(const PulseLoader()),
                ViewState.error => _buildRefreshableState(
                    AsyncStateView(
                      title: 'Failed to fetch anomalies',
                      description: provider.errorMessage ?? 'Could not pull live metrics.',
                      onRetry: provider.fetch,
                      icon: Assets.icons.wifiIcon.svg(
                        width: 25.sp,
                        height: 25.sp,
                        colorFilter: const ColorFilter.mode(
                          AppColors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ViewState.empty => _buildRefreshableState(
                    const AsyncStateView(
                      title: 'No anomalies currently',
                      description: 'Monitoring in real-time. New alerts will appear here.',
                    ),
                  ),
                _ => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 1.2.h),
                    AppSurfaceCard(
                      child: Row(
                        children: [
                          Container(
                            width: 11.w,
                            height: 11.w,
                            decoration: BoxDecoration(
                              color: AppColors.accentMuted,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Assets.icons.monitoringTvIcon.svg(
                                width: 5.2.w,
                                height: 5.2.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.accent,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Monitoring in real-time', style: AppTextStyles.body),
                                Text('Polling Ads API every 30 seconds', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          Text('Live', style: AppTextStyles.body.copyWith(color: AppColors.success)),
                        ],
                      ),
                    ),
                    Text('Recent Anomalies', style: AppTextStyles.sectionTitle),
                    SizedBox(height: 1.h),
                    ...provider.anomalies.map((item) => AnomalyCard(anomaly: item)),
                    SizedBox(height: 2.2.h),
                  ],
                  ),
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRefreshableState(Widget child) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 70.h, child: child),
      ],
    );
  }
}
