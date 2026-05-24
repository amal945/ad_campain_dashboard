import 'dart:developer';

import 'package:ad_campaign_dashboard/core/api/request_handler.dart';
import 'package:ad_campaign_dashboard/core/services/cache_service.dart';
import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/features/campaigns/data/campaign_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/campaign.dart';
import 'package:ad_campaign_dashboard/features/campaigns/model/daily_metric.dart';

class CampaignRepository {
  CampaignRepository(this._remoteDataSource, this._requestHandler, this._cacheService);

  final CampaignRemoteDataSource _remoteDataSource;
  final RequestHandler _requestHandler;
  final CacheService _cacheService;

  Future<Result<List<Campaign>>> getCampaigns() {
    return _requestHandler.handle(() async {
      final raw = await _remoteDataSource.fetchCampaigns();
      final campaigns = raw
          .map((item) => Campaign.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);

      // Caching should never fail the primary API flow.
      try {
        await _cacheService.cacheCampaigns(campaigns.map((item) => item.toJson()).toList());
      } catch (e, stackTrace) {
        log('Campaign cache write failed: $e', name: 'CACHE', stackTrace: stackTrace);
      }

      return campaigns;
    });
  }

  List<Campaign> getCachedCampaigns() {
    final cache = _cacheService.getCachedCampaigns();
    return cache.map(Campaign.fromJson).toList(growable: false);
  }

  Future<Result<Campaign>> getCampaignDetail(String id) {
    return _requestHandler.handle(() async {
      final raw = await _remoteDataSource.fetchCampaignDetail(id);
      return Campaign.fromJson(raw);
    });
  }

  Future<Result<List<DailyMetric>>> getCampaignHistory(String id) {
    return _requestHandler.handle(() async {
      final raw = await _remoteDataSource.fetchCampaignHistory(id);
      return raw
          .map((item) => DailyMetric.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
    });
  }
}
