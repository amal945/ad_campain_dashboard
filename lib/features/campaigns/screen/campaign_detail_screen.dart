import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/campaign.dart';
import 'package:ad_campaign_dashboard/features/campaigns/provider/campaign_detail_provider.dart';
import 'package:ad_campaign_dashboard/features/campaigns/widget/ctr_performance_chart.dart';
import 'package:ad_campaign_dashboard/features/forecast/widget/recommendation_card.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CampaignDetailScreen extends StatelessWidget {
  const CampaignDetailScreen({required this.campaignId, super.key});

  final String campaignId;

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignDetailProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: Assets.icons.backIcon.svg(
                width: 18.sp,
                height: 18.sp,
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            titleSpacing: 0,
            title: provider.campaign == null
                ? Text('Campaign Detail', style: AppTextStyles.title)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.campaign!.name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.2.h),
                      Row(
                        children: [
                          _HeaderPill(
                            label: _statusLabel(provider.campaign!.status),
                            color: _statusColor(provider.campaign!.status),
                          ),
                          SizedBox(width: 1.5.w),
                          _HeaderPill(
                            label: provider.campaign!.objective ?? 'Campaign',
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                    ],
                  ),
            actions: [
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Assets.icons.calendarIcon.svg(
                  width: 18.sp,
                  height: 18.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: RefreshIndicator(
              onRefresh: () => provider.load(campaignId),
              child: switch (provider.state) {
                ViewState.loading => _buildRefreshableState(
                  const _SingleStateCard(
                    type: _StateType.loading,
                    title: 'Loading',
                    description: 'Fetching latest analytics...',
                  ),
                ),
                ViewState.error => _buildRefreshableState(
                  _SingleStateCard(
                    type: _StateType.error,
                    title: 'Failed to load data',
                    description:
                        provider.errorMessage ?? 'Something went wrong',
                    onRetry: () => provider.load(campaignId),
                  ),
                ),
                ViewState.empty => _buildRefreshableState(
                  const _SingleStateCard(
                    type: _StateType.empty,
                    title: 'No data available',
                    description: 'There is no data to display for this period.',
                  ),
                ),
                _ => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: 1.2.h),
                    Row(
                      children: [
                        _KpiTile(
                          label: 'Impressions',
                          value: '${provider.campaign?.impressions ?? 0}K',
                          icon: Assets.icons.eyeIcon,
                        ),
                        _KpiTile(
                          label: 'Clicks',
                          value: '${provider.campaign?.clicks ?? 0}',
                          icon: Assets.icons.cursorIcon,
                        ),
                        _KpiTile(
                          label: 'CTR',
                          value:
                              '${provider.campaign?.ctr.toStringAsFixed(2) ?? '0'}%',
                          icon: Assets.icons.chartUpIcon,
                        ),
                        _KpiTile(
                          label: 'Total spend',
                          value:
                              '${provider.campaign?.spend.toStringAsFixed(0) ?? '0'} SAR',
                          icon: Assets.icons.calendarIcon,
                        ),
                      ],
                    ),
                    SizedBox(height: 1.6.h),
                    Text(
                      'CTR Performance & Forecast',
                      style: AppTextStyles.sectionTitle,
                    ),
                    SizedBox(height: 1.h),
                    CtrPerformanceChart(
                      history: provider.history,
                      forecast: provider.forecast,
                    ),
                    SizedBox(height: 0.8.h),
                    RecommendationCard(message: provider.recommendationText()),
                    SizedBox(height: 2.4.h),
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
      children: [SizedBox(height: 70.h, child: child)],
    );
  }

  String _statusLabel(CampaignStatus status) {
    return switch (status) {
      CampaignStatus.active => 'Active',
      CampaignStatus.paused => 'Paused',
      CampaignStatus.ended => 'Ended',
      CampaignStatus.unknown => 'Unknown',
    };
  }

  Color _statusColor(CampaignStatus status) {
    return switch (status) {
      CampaignStatus.active => AppColors.success,
      CampaignStatus.paused => AppColors.warning,
      CampaignStatus.ended => AppColors.textSecondary,
      CampaignStatus.unknown => AppColors.textSecondary,
    };
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final SvgGenImage icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 1.w),
        padding: EdgeInsets.symmetric(vertical: 0.7.h, horizontal: 0.5.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            icon.svg(
              width: 14.sp,
              height: 14.sp,
              colorFilter: const ColorFilter.mode(
                AppColors.accent,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 0.4.h),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(fontSize: 14.sp),
            ),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.15.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(color: color, fontSize: 13.sp),
      ),
    );
  }
}

enum _StateType { loading, empty, error }

class _SingleStateCard extends StatelessWidget {
  const _SingleStateCard({
    required this.type,
    required this.title,
    required this.description,
    this.onRetry,
  });

  final _StateType type;
  final String title;
  final String description;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      _StateType.loading => SizedBox(
        width: 20.sp,
        height: 20.sp,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.accent,
        ),
      ),
      _StateType.empty => Assets.icons.outOfStockIcon.svg(
        width: 20.sp,
        height: 20.sp,
        colorFilter: const ColorFilter.mode(
          AppColors.textSecondary,
          BlendMode.srcIn,
        ),
      ),
      _StateType.error => Assets.icons.chartDownIcon.svg(
        width: 20.sp,
        height: 20.sp,
        colorFilter: const ColorFilter.mode(AppColors.danger, BlendMode.srcIn),
      ),
    };

    final iconBg = switch (type) {
      _StateType.loading => AppColors.surface,
      _StateType.empty => const Color(0xFF3F414D),
      _StateType.error => const Color(0xFF472B31),
    };

    return Padding(
      padding: EdgeInsets.only(top: 8.h, left: 3.w, right: 3.w),
      child: Container(
        padding: EdgeInsets.all(2.2.h),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: icon),
            ),
            SizedBox(height: 1.3.h),
            Text(
              title,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 0.4.h),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(fontSize: 14.sp),
            ),
            if (type == _StateType.error && onRetry != null) ...[
              SizedBox(height: 1.2.h),
              InkWell(
                onTap: onRetry,
                child: Text(
                  'Retry',
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16.sp,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
