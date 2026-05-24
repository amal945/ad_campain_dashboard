import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TopCampaignTile extends StatelessWidget {
  const TopCampaignTile({
    required this.rank,
    required this.name,
    required this.ctr,
    super.key,
  });

  final int rank;
  final String name;
  final double ctr;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 1.2.h),
      padding: EdgeInsets.symmetric(vertical: 1.2.h, horizontal: 1.6.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentMuted,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text('$rank', style: AppTextStyles.caption),
          ),
          SizedBox(width: 3.w),
          Expanded(child: Text(name, style: AppTextStyles.body)),
          Text(
            '${ctr.toStringAsFixed(1)}%',
            style: AppTextStyles.body.copyWith(color: AppColors.success),
          ),
        ],
      ),
    );
  }
}
