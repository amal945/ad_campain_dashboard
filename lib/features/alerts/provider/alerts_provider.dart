import 'dart:async';

import 'package:ad_campaign_dashboard/core/services/notification_service.dart';
import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/features/alerts/model/anomaly.dart';
import 'package:ad_campaign_dashboard/features/alerts/repository/alerts_repository.dart';
import 'package:flutter/foundation.dart';

class AlertsProvider extends ChangeNotifier {
  AlertsProvider(this._repository, this._notificationService);

  final AlertsRepository _repository;
  final NotificationService _notificationService;

  ViewState state = ViewState.idle;
  List<Anomaly> anomalies = <Anomaly>[];
  String? errorMessage;
  Timer? _pollingTimer;
  final Set<String> _notifiedIds = <String>{};

  Future<void> startPolling() async {
    await fetch();
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) => fetch());
  }

  void stopPolling() {
    _pollingTimer?.cancel();
  }

  Future<void> fetch() async {
    if (state != ViewState.success) {
      state = ViewState.loading;
      notifyListeners();
    }

    final result = await _repository.fetchAnomalies();
    switch (result) {
      case Success<List<Anomaly>>():
        anomalies = result.data;
        state = anomalies.isEmpty ? ViewState.empty : ViewState.success;
        for (final anomaly in anomalies) {
          if (!_notifiedIds.contains(anomaly.id)) {
            _notifiedIds.add(anomaly.id);
            await _notificationService.showAnomalyNotification(
              anomaly.type,
              '${anomaly.campaignName}: ${anomaly.changePercent.toStringAsFixed(0)}% change detected',
            );
          }
        }
      case Failure<List<Anomaly>>():
        errorMessage = result.message;
        state = ViewState.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
