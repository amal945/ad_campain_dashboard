import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/campaign.dart';
import 'package:ad_campaign_dashboard/features/campaigns/repository/campaign_repository.dart';
import 'package:flutter/foundation.dart';

class CampaignListProvider extends ChangeNotifier {
  CampaignListProvider(this._repository);

  final CampaignRepository _repository;

  ViewState state = ViewState.idle;
  List<Campaign> _allCampaigns = <Campaign>[];
  CampaignStatus? selectedFilter;
  String? errorMessage;

  List<Campaign> get campaigns {
    if (selectedFilter == null) {
      return _allCampaigns;
    }
    return _allCampaigns.where((item) => item.status == selectedFilter).toList();
  }

  Future<void> loadCampaigns({bool allowCache = true}) async {
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();

    if (allowCache) {
      final cache = _repository.getCachedCampaigns();
      if (cache.isNotEmpty) {
        _allCampaigns = cache;
        state = ViewState.success;
        notifyListeners();
      }
    }

    final result = await _repository.getCampaigns();
    switch (result) {
      case Success<List<Campaign>>():
        _allCampaigns = result.data;
        state = _allCampaigns.isEmpty ? ViewState.empty : ViewState.success;
      case Failure<List<Campaign>>():
        errorMessage = result.message;
        state = _allCampaigns.isNotEmpty ? ViewState.success : ViewState.error;
    }
    notifyListeners();
  }

  void applyFilter(CampaignStatus? filter) {
    selectedFilter = filter;
    notifyListeners();
  }
}
