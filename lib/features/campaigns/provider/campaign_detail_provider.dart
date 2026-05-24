import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/campaign.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/daily_metric.dart';
import 'package:ad_campaign_dashboard/features/campaigns/repository/campaign_repository.dart';
import 'package:ad_campaign_dashboard/features/forecast/model/forecast_point.dart';
import 'package:ad_campaign_dashboard/features/forecast/repository/forecast_repository.dart';
import 'package:flutter/foundation.dart';

class CampaignDetailProvider extends ChangeNotifier {
  CampaignDetailProvider(this._campaignRepository, this._forecastRepository);

  final CampaignRepository _campaignRepository;
  final ForecastRepository _forecastRepository;

  ViewState state = ViewState.idle;
  Campaign? campaign;
  List<DailyMetric> history = <DailyMetric>[];
  List<ForecastPoint> forecast = <ForecastPoint>[];
  String? errorMessage;

  Future<void> load(String campaignId) async {
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();

    final detail = await _campaignRepository.getCampaignDetail(campaignId);
    if (detail is Failure<Campaign>) {
      state = ViewState.error;
      errorMessage = detail.message;
      notifyListeners();
      return;
    }
    campaign = (detail as Success<Campaign>).data;

    final historyResult = await _campaignRepository.getCampaignHistory(campaignId);
    if (historyResult is Failure<List<DailyMetric>>) {
      state = ViewState.error;
      errorMessage = historyResult.message;
      notifyListeners();
      return;
    }
    history = (historyResult as Success<List<DailyMetric>>).data;

    final forecastResult =
        await _forecastRepository.getCtrForecast(campaignId: campaignId, history: history);
    if (forecastResult is Failure<List<ForecastPoint>>) {
      state = ViewState.error;
      errorMessage = forecastResult.message;
      notifyListeners();
      return;
    }
    forecast = (forecastResult as Success<List<ForecastPoint>>).data;
    state = (history.isEmpty && forecast.isEmpty) ? ViewState.empty : ViewState.success;
    notifyListeners();
  }

  String recommendationText() {
    if (history.isEmpty || forecast.isEmpty) {
      return 'Insufficient data for recommendation.';
    }
    final historicalAvg = history.map((item) => item.ctr).reduce((a, b) => a + b) / history.length;
    final forecastAvg =
        forecast.map((item) => item.predictedCtr).reduce((a, b) => a + b) / forecast.length;
    final change = ((forecastAvg - historicalAvg) / (historicalAvg == 0 ? 1 : historicalAvg)) * 100;

    if (change >= 0) {
      return 'CTR is predicted to increase by ${change.toStringAsFixed(1)}%. Consider increasing budget to maximize returns.';
    }
    return 'CTR may drop by ${change.abs().toStringAsFixed(1)}%. Consider testing new creatives and audience targeting.';
  }
}
