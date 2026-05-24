import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/daily_metric.dart';
import 'package:ad_campaign_dashboard/features/forecast/model/forecast_point.dart';
import 'package:ad_campaign_dashboard/features/forecast/repository/forecast_repository.dart';
import 'package:flutter/foundation.dart';

class ForecastProvider extends ChangeNotifier {
  ForecastProvider(this._repository);

  final ForecastRepository _repository;

  ViewState state = ViewState.idle;
  List<ForecastPoint> points = <ForecastPoint>[];
  String? errorMessage;

  Future<void> loadForecast(String campaignId, List<DailyMetric> history) async {
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();

    final result = await _repository.getCtrForecast(campaignId: campaignId, history: history);
    switch (result) {
      case Success<List<ForecastPoint>>():
        points = result.data;
        state = points.isEmpty ? ViewState.empty : ViewState.success;
      case Failure<List<ForecastPoint>>():
        errorMessage = result.message;
        state = ViewState.error;
    }
    notifyListeners();
  }
}
