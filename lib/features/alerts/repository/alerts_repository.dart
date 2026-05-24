import 'package:ad_campaign_dashboard/core/api/request_handler.dart';
import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/features/alerts/data/alerts_remote_data_source.dart';
import 'package:ad_campaign_dashboard/features/alerts/model/anomaly.dart';
import 'package:ad_campaign_dashboard/features/alerts/model/snapshot.dart';

class AlertsRepository {
  AlertsRepository(this._remoteDataSource, this._requestHandler);

  final AlertsRemoteDataSource _remoteDataSource;
  final RequestHandler _requestHandler;

  Future<Result<List<Anomaly>>> fetchAnomalies() {
    return _requestHandler.handle(() async {
      final snapshotJson = await _remoteDataSource.fetchLiveMetrics();
      final snapshot = Snapshot.fromJson(snapshotJson);
      final raw = await _remoteDataSource.detectAnomaly(snapshot);
      return raw
          .map((item) => Anomaly.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
    });
  }
}
