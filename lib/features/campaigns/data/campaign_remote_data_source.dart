import 'package:ad_campaign_dashboard/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart';

class CampaignRemoteDataSource {
  CampaignRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<dynamic>> fetchCampaigns() async {
    final response = await _dio.get(ApiEndpoints.campaigns);
    return response.data['campaigns'] as List<dynamic>? ?? <dynamic>[];
  }

  Future<Map<String, dynamic>> fetchCampaignDetail(String id) async {
    final response = await _dio.get(ApiEndpoints.campaignDetail(id));
    return Map<String, dynamic>.from(response.data['campaign'] as Map? ?? <String, dynamic>{});
  }

  Future<List<dynamic>> fetchCampaignHistory(String id) async {
    final response = await _dio.get(ApiEndpoints.campaignHistory(id));
    return response.data['history'] as List<dynamic>? ?? <dynamic>[];
  }
}
