import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/core/widgets/app_surface_card.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/daily_metric.dart';
import 'package:ad_campaign_dashboard/features/forecast/model/forecast_point.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CtrPerformanceChart extends StatelessWidget {
  const CtrPerformanceChart({
    required this.history,
    required this.forecast,
    super.key,
  });

  final List<DailyMetric> history;
  final List<ForecastPoint> forecast;

  @override
  Widget build(BuildContext context) {
    final splitX = history.isEmpty ? 0 : history.length - 1;
    final historySpots = history.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.ctr * 100);
    }).toList();

    final forecastSpots = forecast.asMap().entries.map((entry) {
      return FlSpot((history.length + entry.key).toDouble(), entry.value.predictedCtr * 100);
    }).toList();

    final lower = forecast.asMap().entries.map((entry) {
      return FlSpot((history.length + entry.key).toDouble(), entry.value.lowerBound * 100);
    }).toList();
    final upper = forecast.asMap().entries.map((entry) {
      return FlSpot((history.length + entry.key).toDouble(), entry.value.upperBound * 100);
    }).toList();

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'CTR Performance & Forecast',
                        style: AppTextStyles.sectionTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Icon(Icons.info_outline, size: 15.sp, color: AppColors.textSecondary),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.45.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '30 Days',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 16.sp),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 0.8.h),
          Wrap(
            spacing: 5.w,
            runSpacing: 0.6.h,
            children: [
              _legend(color: AppColors.accent, label: 'Historical CTR'),
              _legend(color: const Color(0xFF59D8E5), label: 'Forecast CTR', dashed: true),
            ],
          ),
          SizedBox(height: 0.8.h),
          Text('CTR (%)', style: AppTextStyles.caption.copyWith(fontSize: 16.sp)),
          SizedBox(height: 0.8.h),
          SizedBox(
            height: 22.h,
            child: LineChart(
              duration: const Duration(milliseconds: 600),
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: AppColors.cardBorder, strokeWidth: 0.8),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: true),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 26,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}%',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: ((history.length + forecast.length) / 4).clamp(1, 1000).toDouble(),
                      getTitlesWidget: (value, meta) => Padding(
                        padding: EdgeInsets.only(top: 0.6.h),
                        child: Text(
                          _labelForX(value.toInt(), history, forecast),
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                minY: 0,
                maxY: 6.5,
                extraLinesData: ExtraLinesData(
                  verticalLines: [
                    VerticalLine(
                      x: splitX.toDouble(),
                      color: AppColors.textSecondary.withValues(alpha: 0.45),
                      strokeWidth: 1,
                      dashArray: [6, 4],
                    ),
                  ],
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: historySpots,
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 1.8,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.25),
                          AppColors.accent.withValues(alpha: 0.02),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: forecastSpots,
                    isCurved: true,
                    color: const Color(0xFF59D8E5),
                    barWidth: 1.8,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: lower,
                    isCurved: true,
                    color: AppColors.accent.withValues(alpha: 0),
                    barWidth: 0,
                    dotData: const FlDotData(show: false),
                  ),
                  LineChartBarData(
                    spots: upper,
                    isCurved: true,
                    color: AppColors.accent.withValues(alpha: 0),
                    barWidth: 0,
                    dotData: const FlDotData(show: false),
                  ),
                ],
                betweenBarsData: [
                  BetweenBarsData(
                    fromIndex: 2,
                    toIndex: 3,
                    color: AppColors.accent.withValues(alpha: 0.18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend({required Color color, required String label, bool dashed = false}) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 0.25.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
          child: dashed
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    return Row(
                      children: List.generate(
                        4,
                        (_) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            color: color,
                          ),
                        ),
                      ),
                    );
                  },
                )
              : null,
        ),
        SizedBox(width: 1.5.w),
        Text(
          label,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
      ],
    );
  }

  String _labelForX(int index, List<DailyMetric> history, List<ForecastPoint> forecast) {
    DateTime? date;
    if (index < history.length && index >= 0) {
      date = history[index].date;
    } else {
      final forecastIndex = index - history.length;
      if (forecastIndex >= 0 && forecastIndex < forecast.length) {
        date = forecast[forecastIndex].date;
      }
    }
    if (date == null) {
      return '';
    }
    final day = date.day.toString().padLeft(2, '0');
    final month = _monthShort(date.month);
    return '$day $month';
  }

  String _monthShort(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[(month - 1).clamp(0, 11)];
  }
}
