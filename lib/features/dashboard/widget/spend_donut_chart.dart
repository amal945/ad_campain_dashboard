import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SpendDonutChart extends StatelessWidget {
  const SpendDonutChart({required this.values, super.key});

  final Map<String, double> values;

  @override
  Widget build(BuildContext context) {
    final entries = values.entries.toList();
    final total = entries.fold<double>(0, (a, b) => a + b.value);

    if (entries.isEmpty || total <= 0) {
      return SizedBox(
        height: 16.h,
        child: Center(
          child: Text(
            'No channel data available',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
          ),
        ),
      );
    }

    final colors = [
      AppColors.accent,
      AppColors.chartBlue,
      AppColors.chartPurple,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 32.w,
          height: 32.w,
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 8.w,
              sectionsSpace: 0,
              startDegreeOffset: -90,
              sections: entries.asMap().entries.map((entry) {
                return PieChartSectionData(
                  color: colors[entry.key % colors.length],
                  value: entry.value.value,
                  radius: 7.w,
                  showTitle: false,
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: entries.asMap().entries.map((entry) {
              final isLast = entry.key == entries.length - 1;
              final percent = (entry.value.value / total) * 100;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      children: [
                        Container(
                          width: 2.4.w,
                          height: 2.4.w,
                          decoration: BoxDecoration(
                            color: colors[entry.key % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            entry.value.key,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Text(
                          '${percent.toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 0,
                      thickness: 0.6,
                      color: AppColors.cardBorder,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
