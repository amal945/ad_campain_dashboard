import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

abstract final class AppTextStyles {
  static TextStyle title = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle sectionTitle = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static TextStyle caption = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle value = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );
}
