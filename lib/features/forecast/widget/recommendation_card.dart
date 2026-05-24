import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    required this.message,
    super.key,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.8.h, vertical: 1.4.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.card,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 9.w,
            height: 9.w,
            decoration: BoxDecoration(
              color: const Color(0xFF163B32),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Assets.icons.tradeUpIcon.svg(
                width: 17.sp,
                height: 17.sp,
                colorFilter: const ColorFilter.mode(
                  AppColors.success,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          SizedBox(width: 2.8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Budget Recommendation',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.success,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(height: 0.3.h),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body.copyWith(fontSize: 15.sp),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.success),
              foregroundColor: AppColors.success,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {},
            child: Text('View Details', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}
