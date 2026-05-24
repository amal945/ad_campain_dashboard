import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/campaign.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({required this.campaign, required this.onTap, super.key});

  final Campaign campaign;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (campaign.status) {
      case CampaignStatus.active:
        statusColor = AppColors.success;
      case CampaignStatus.paused:
        statusColor = AppColors.warning;
      case CampaignStatus.ended:
      case CampaignStatus.unknown:
        statusColor = AppColors.textSecondary;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 1.2.h),
        padding: EdgeInsets.all(1.2.h),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 8.5.w,
                  height: 8.5.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF133F4A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: _getCampaignIcon(campaign).svg(
                      width: 4.6.w,
                      height: 4.6.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.accent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaign.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 17.sp,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 0.25.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1.5.w,
                          vertical: 0.1.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentMuted,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          (campaign.objective ?? 'Campaign'),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.accent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 1.8.w,
                    vertical: 0.2.h,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(color: statusColor, fontSize: 14.sp),
                      ),
                      Text(
                        _statusLabel(campaign.status),
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: statusColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 1.5.w),
                Text(
                  '⋯',
                  style: AppTextStyles.caption.copyWith(fontSize: 18.sp),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Total spend',
              style: AppTextStyles.caption.copyWith(fontSize: 13.sp),
            ),
            SizedBox(height: 0.2.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${campaign.spend.toStringAsFixed(0)} SAR',
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 15.sp),
                  ),
                  TextSpan(
                    text: ' / ${campaign.budget.toStringAsFixed(0)} SAR',
                    style: AppTextStyles.caption.copyWith(fontSize: 13.5.sp),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: campaign.spendProgress,
                      minHeight: 0.45.h,
                      backgroundColor: const Color(0xFF4A4E5C),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  '${(campaign.spendProgress * 100).toStringAsFixed(0)}%',
                  style: AppTextStyles.caption.copyWith(fontSize: 13.sp),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                _MetricTile(
                  label: 'Impressions',
                  value: _compact(campaign.impressions.toDouble()),
                  icon: Assets.icons.eyeIcon.svg(
                    width: 4.2.w,
                    height: 4.2.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.accent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                _MetricTile(
                  label: 'Clicks',
                  value: _compact(campaign.clicks.toDouble()),
                  icon: Assets.icons.cursorIcon.svg(
                    width: 4.2.w,
                    height: 4.2.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.accent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                _MetricTile(
                  label: 'CTR',
                  value: '${campaign.ctr.toStringAsFixed(2)}%',
                  icon: Assets.icons.chartUpIcon.svg(
                    width: 4.2.w,
                    height: 4.2.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.accent,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: _BottomInfo(
                    label: 'Start date',
                    value: _formatDate(campaign.startDate),
                    icon: Assets.icons.calendarIcon.svg(
                      width: 3.8.w,
                      height: 3.8.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.accent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _BottomInfo(
                    label: 'Audience',
                    value: campaign.audience ?? 'All Users, KSA',
                    icon: Assets.icons.targetIcon.svg(
                      width: 3.8.w,
                      height: 3.8.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.accent,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SvgGenImage _getCampaignIcon(Campaign campaign) {
    final name = campaign.name.toLowerCase();
    final objective = campaign.objective?.toLowerCase() ?? '';

    if (objective == 'awareness') {
      return Assets.icons.megaphoneIcon;
    }
    if (name.contains('offer') ||
        name.contains('gift') ||
        name.contains('ramadan') ||
        name.contains('loyalty') ||
        objective == 'engagement') {
      return Assets.icons.giftIcon;
    }
    return Assets.icons.cartIcon;
  }

  String _statusLabel(CampaignStatus status) {
    return switch (status) {
      CampaignStatus.active => 'Active',
      CampaignStatus.paused => 'Paused',
      CampaignStatus.ended => 'Ended',
      CampaignStatus.unknown => 'Unknown',
    };
  }

  String _compact(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return 'N/A';
    }
    final date = DateTime.tryParse(raw);
    if (date == null) {
      return raw;
    }
    return DateFormat('dd MMM yyyy').format(date);
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 2.w),
        padding: EdgeInsets.symmetric(vertical: 0.8.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            icon,
            SizedBox(height: 0.4.h),
            Text(
              value,
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 14.sp),
            ),
            SizedBox(height: 0.2.h),
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }
}

class _BottomInfo extends StatelessWidget {
  const _BottomInfo({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(fontSize: 15.sp),
              ),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
