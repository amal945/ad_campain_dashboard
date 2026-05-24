import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AsyncStateView extends StatelessWidget {
  const AsyncStateView({
    required this.title,
    required this.description,
    super.key,
    this.onRetry,
    this.icon,
  });

  final String title;
  final String description;
  final VoidCallback? onRetry;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ??
                Assets.icons.infoIcon.svg(
                  width: 28.sp,
                  height: 28.sp,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textSecondary,
                    BlendMode.srcIn,
                  ),
                ),
            SizedBox(height: 1.h),
            Text(title, style: AppTextStyles.sectionTitle, textAlign: TextAlign.center),
            SizedBox(height: 0.8.h),
            Text(
              description,
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 1.6.h),
              OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
