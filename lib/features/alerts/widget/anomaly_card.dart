import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/core/widgets/app_surface_card.dart';
import 'package:ad_campaign_dashboard/features/alerts/model/anomaly.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AnomalyCard extends StatelessWidget {
  const AnomalyCard({required this.anomaly, super.key});

  final Anomaly anomaly;

  @override
  Widget build(BuildContext context) {
    final isHigh = anomaly.severity == AnomalySeverity.high;
    final accent = isHigh ? AppColors.danger : AppColors.warning;

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    (isHigh ? Assets.icons.chartUpIcon : Assets.icons.tradeDownIcon).svg(
                      width: 13.sp,
                      height: 13.sp,
                      colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      anomaly.type,
                      style: AppTextStyles.caption.copyWith(
                        color: accent,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(anomaly.timestamp, style: AppTextStyles.caption),
            ],
          ),
          SizedBox(height: 0.6.h),
          Text(anomaly.campaignName, style: AppTextStyles.sectionTitle),
          SizedBox(height: 0.8.h),
          Text(
            'Spend is ${anomaly.changePercent.toStringAsFixed(0)}% higher than usual',
            style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 1.2.h),
          Row(
            children: [
              _Metric(value: '${anomaly.spend.toStringAsFixed(0)} SAR', label: 'Spend'),
              _Metric(value: '${anomaly.expected.toStringAsFixed(0)} SAR', label: 'Expected'),
              _Metric(
                value: '${anomaly.changePercent > 0 ? '+' : ''}${anomaly.changePercent.toStringAsFixed(0)}%',
                label: 'Change',
                accent: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label, this.accent});

  final String value;
  final String label;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 2.w),
        padding: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.body.copyWith(
                fontSize: 14.sp,
                color: accent ?? AppColors.textPrimary,
              ),
            ),
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12.sp)),
          ],
        ),
      ),
    );
  }
}
