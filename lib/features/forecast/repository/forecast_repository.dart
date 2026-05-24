import 'package:ad_campaign_dashboard/core/api/request_handler.dart';
import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/daily_metric.dart';
import 'package:ad_campaign_dashboard/features/forecast/data/forecast_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/forecast/model/forecast_point.dart';

class ForecastRepository {
  ForecastRepository(this._remoteDataSource, this._requestHandler);

  final ForecastRemoteDataSource _remoteDataSource;
  final RequestHandler _requestHandler;

  Future<Result<List<ForecastPoint>>> getCtrForecast({
    required String campaignId,
    required List<DailyMetric> history,
  }) {
    return _requestHandler.handle(() async {
      final raw = await _remoteDataSource.fetchForecast(
        campaignId: campaignId,
        history: history,
      );
      return raw
          .map((item) => ForecastPoint.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
    });
  }
}
