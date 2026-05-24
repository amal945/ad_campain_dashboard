import 'package:ad_campaign_dashboard/core/theme/app_colors.dart';
import 'package:ad_campaign_dashboard/core/theme/app_text_styles.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/core/widgets/async_state_view.dart';
import 'package:ad_campaign_dashboard/core/widgets/pulse_loader.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/campaign.dart';
import 'package:ad_campaign_dashboard/features/campaigns/provider/campaign_list_provider.dart';
import 'package:ad_campaign_dashboard/features/campaigns/widget/campaign_card.dart';
import 'package:ad_campaign_dashboard/features/campaigns/widget/campaign_filter_tabs.dart';
import 'package:ad_campaign_dashboard/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CampaignListProvider>(
      builder: (context, provider, _) {
        final visibleCampaigns = provider.campaigns.where((item) {
          final query = _searchController.text.trim().toLowerCase();
          return query.isEmpty || item.name.toLowerCase().contains(query);
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Campaign List', style: AppTextStyles.title),
            leading: Padding(
              padding: EdgeInsets.all(3.2.w),
              child: Assets.icons.menuIcon.svg(
                colorFilter: const ColorFilter.mode(
                  AppColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: provider.loadCampaigns,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                children: [
Container(
  margin: EdgeInsets.symmetric(vertical: 1.2.h),
  decoration: BoxDecoration(
    color: const Color(0xFF1C1A24),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(
      color: const Color(0xFF2A2833),
      width: 1,
    ),
  ),
  child: TextField(
    controller: _searchController,
    onChanged: (_) => setState(() {}),
    style: AppTextStyles.body.copyWith(
      color: Colors.white,
      fontSize: 15.sp,
    ),
    cursorColor: Colors.white,
    decoration: InputDecoration(
      hintText: 'Search Campaigns...',
      hintStyle: AppTextStyles.body.copyWith(
        color: const Color(0xFF8E8B99),
        fontSize: 15.sp,
      ),

      filled: true,
      fillColor: Colors.transparent,

      isDense: true,

      contentPadding: EdgeInsets.symmetric(
        vertical: 1.7.h,
      ),

      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,

      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 4.w, right: 2.w),
        child: Assets.icons.searchIcon.svg(
          width: 18.sp,
          height: 18.sp,
          colorFilter: const ColorFilter.mode(
            Color(0xFFB0ADB8),
            BlendMode.srcIn,
          ),
        ),
      ),

      prefixIconConstraints: BoxConstraints(
        minWidth: 12.w,
        minHeight: 6.h,
      ),

      suffixIcon: Padding(
        padding: EdgeInsets.only(right: 4.w),
        child: Assets.icons.filterIcon.svg(
          width: 18.sp,
          height: 18.sp,
          colorFilter: const ColorFilter.mode(
            Color(0xFFB0ADB8),
            BlendMode.srcIn,
          ),
        ),
      ),

      suffixIconConstraints: BoxConstraints(
        minWidth: 12.w,
        minHeight: 6.h,
      ),
    ),
  ),
),
                  CampaignFilterTabs(
                    selectedFilter: provider.selectedFilter,
                    onChanged: provider.applyFilter,
                  ),
                  SizedBox(height: 1.6.h),
                  Expanded(
                    child: switch (provider.state) {
                      ViewState.loading => _buildRefreshableState(const PulseLoader()),
                      ViewState.error => _buildRefreshableState(
                          AsyncStateView(
                          title: 'Unable to load campaigns',
                          description: provider.errorMessage ?? 'Unexpected error occurred',
                          icon: Assets.icons.wifiIcon.svg(
                            width: 25.sp,
                            height: 25.sp,
                            colorFilter: const ColorFilter.mode(
                              AppColors.textSecondary,
                              BlendMode.srcIn,
                            ),
                          ),
                          onRetry: provider.loadCampaigns,
                        )),
                      ViewState.empty => _buildRefreshableState(
                          const AsyncStateView(
                          title: 'No campaigns found',
                          description: 'Try adjusting filters or pull to refresh.',
                        )),
                      _ => ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: visibleCampaigns.length,
                          itemBuilder: (context, index) {
                            final campaign = visibleCampaigns[index];
                            return TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 220 + (index * 70)),
                              tween: Tween<double>(begin: 0, end: 1),
                              builder: (context, value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, (1 - value) * 14),
                                    child: child,
                                  ),
                                );
                              },
                              child: CampaignCard(
                                campaign: campaign,
                                onTap: () => _openCampaign(context, campaign),
                              ),
                            );
                          },
                        ),
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openCampaign(BuildContext context, Campaign campaign) {
    context.push('/campaigns/${campaign.id}');
  }

  Widget _buildRefreshableState(Widget child) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: 62.h,
          child: child,
        ),
      ],
    );
  }
}
