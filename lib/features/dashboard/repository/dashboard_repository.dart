import 'package:ad_campaign_dashboard/core/api/request_handler.dart';
import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/features/dashboard/data/dashboard_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/dashboard/model/summary.dart';

class DashboardRepository {
  DashboardRepository(this._remoteDataSource, this._requestHandler);

  final DashboardRemoteDataSource _remoteDataSource;
  final RequestHandler _requestHandler;

  Future<Result<Summary>> getSummary(int days) {
    return _requestHandler.handle(() async {
      final raw = await _remoteDataSource.fetchSummary(days);
      return Summary.fromJson(raw);
    });
  }
}
