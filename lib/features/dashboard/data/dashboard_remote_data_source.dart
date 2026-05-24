import 'package:ad_campaign_dashboard/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> fetchSummary(int days) async {
    final response = await _dio.get(
      ApiEndpoints.campaignsSummary,
      queryParameters: {'days': days},
    );
    return Map<String, dynamic>.from(response.data['summary'] as Map? ?? <String, dynamic>{});
  }
}
