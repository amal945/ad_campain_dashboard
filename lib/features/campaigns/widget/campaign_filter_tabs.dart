import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/campaign.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CampaignFilterTabs extends StatelessWidget {
  const CampaignFilterTabs({
    required this.selectedFilter,
    required this.onChanged,
    super.key,
  });

  final CampaignStatus? selectedFilter;
  final ValueChanged<CampaignStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = <(String, CampaignStatus?)>[
      ('All', null),
      ('Active', CampaignStatus.active),
      ('Paused', CampaignStatus.paused),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: options.map((item) {
        final selected = selectedFilter == item.$2;
        return Padding(
          padding: EdgeInsets.only(right: 2.5.w),
          child: GestureDetector(
            onTap: () => onChanged(item.$2),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(
                vertical: 0.8.h,
                horizontal: 5.w,
              ),
              decoration: BoxDecoration(
                color: selected ? AppColors.accentMuted : AppColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: selected ? AppColors.accent : AppColors.cardBorder,
                ),
              ),
              child: Text(
                item.$1,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: selected
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
