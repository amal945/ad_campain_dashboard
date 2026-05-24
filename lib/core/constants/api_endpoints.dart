abstract final class ApiEndpoints {
  static const campaigns = '/campaigns';
  static String campaignDetail(String id) => '/campaigns/$id';
  static String campaignHistory(String id) => '/campaigns/$id/history';
  static const campaignsSummary = '/campaigns/summary';
  static const campaignsLiveMetrics = '/campaigns/metrics/live';

  static const forecastCtr = '/forecast/ctr';
  static const detectAnomaly = '/anomaly/detect';
}
