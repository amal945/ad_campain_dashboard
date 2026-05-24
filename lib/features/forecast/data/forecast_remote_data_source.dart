import 'package:ad_campaign_dashboard/core/constants/api_endpoints.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/daily_metric.dart';
import 'package:dio/dio.dart';

class ForecastRemoteDataSource {
  ForecastRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<dynamic>> fetchForecast({
    required String campaignId,
    required List<DailyMetric> history,
    int horizon = 7,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.forecastCtr,
      data: {
        'campaign_id': campaignId,
        'history': history.map((item) => item.toJson()).toList(growable: false),
        'horizon_days': horizon,
      },
    );
    return response.data['forecast'] as List<dynamic>? ?? <dynamic>[];
  }
}
