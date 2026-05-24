import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/core/widgets/app_surface_card.dart';
import 'package:ad_campaign_dashboard/core/widgets/async_state_view.dart';
import 'package:ad_campaign_dashboard/core/widgets/pulse_loader.dart';
import 'package:ad_campaign_dashboard/features/dashboard/provider/dashboard_provider.dart';
import 'package:ad_campaign_dashboard/features/dashboard/widget/spend_donut_chart.dart';
import 'package:ad_campaign_dashboard/features/dashboard/widget/top_campaign_tile.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
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
            title: Text('Spend Summary', style: AppTextStyles.title),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: RefreshIndicator(
              onRefresh: () => provider.loadSummary(days: provider.selectedDays),
              child: switch (provider.state) {
                ViewState.loading => _buildRefreshableState(const PulseLoader()),
                ViewState.error => _buildRefreshableState(
                    AsyncStateView(
                      title: 'Failed to load summary',
                      description: provider.errorMessage ?? 'Unexpected dashboard error',
                      onRetry: provider.loadSummary,
                    ),
                  ),
                ViewState.empty => _buildRefreshableState(
                    const AsyncStateView(
                      title: 'No summary data',
                      description: 'No spend data available for this range.',
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
                              color: AppColors.success.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Assets.icons.chartIncrease.svg(
                                width: 5.4.w,
                                height: 5.4.w,
                                colorFilter: const ColorFilter.mode(
                                  AppColors.success,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Spend', style: AppTextStyles.caption),
                              Text(
                                '${provider.summary?.totalSpend.toStringAsFixed(0) ?? '0'} SAR',
                                style: AppTextStyles.title,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    AppSurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Spend by channel', style: AppTextStyles.sectionTitle),
                          SizedBox(height: 1.4.h),
                          SpendDonutChart(values: provider.summary?.channelSpend ?? {}),
                        ],
                      ),
                    ),
                    AppSurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Top 3 Campaigns by CTR', style: AppTextStyles.sectionTitle),
                          SizedBox(height: 1.2.h),
                          ...?provider.summary?.topCampaignsByCtr.take(3).toList().asMap().entries.map(
                                (entry) => TopCampaignTile(
                                  rank: entry.key + 1,
                                  name: entry.value.name,
                                  ctr: entry.value.ctr,
                                ),
                              ),
                        ],
                      ),
                    ),
                    AppSurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date Range', style: AppTextStyles.sectionTitle),
                          SizedBox(height: 1.2.h),
                          Row(
                            children: [7, 14, 30].map((days) {
                              final selected = provider.selectedDays == days;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 2.w),
                                  child: GestureDetector(
                                    onTap: () => provider.loadSummary(days: days),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 250),
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 0.8.h),
                                      decoration: BoxDecoration(
                                        color: selected ? AppColors.accentMuted : AppColors.surface,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: selected ? AppColors.accent : AppColors.cardBorder,
                                        ),
                                      ),
                                      child: Text(
                                        'Last $days Days',
                                        style: AppTextStyles.caption.copyWith(
                                          color: selected
                                              ? AppColors.accent
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
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
