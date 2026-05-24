import 'package:ad_campaign_dashboard/core/constants/api_endpoints.dart';
import 'package:ad_campaign_dashboard/features/alerts/model/snapshot.dart';
import 'package:dio/dio.dart';

class AlertsRemoteDataSource {
  AlertsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> fetchLiveMetrics() async {
    final response = await _dio.get(ApiEndpoints.campaignsLiveMetrics);
    return Map<String, dynamic>.from(response.data['snapshot'] as Map? ?? <String, dynamic>{});
  }

  Future<List<dynamic>> detectAnomaly(Snapshot snapshot) async {
    final response = await _dio.post(
      ApiEndpoints.detectAnomaly,
      data: snapshot.toJson(),
    );
    return response.data['anomalies'] as List<dynamic>? ?? <dynamic>[];
  }
}
