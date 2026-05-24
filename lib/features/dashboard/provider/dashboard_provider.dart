import 'package:ad_campaign_dashboard/core/utils/result.dart';
import 'package:ad_campaign_dashboard/core/utils/view_state.dart';
import 'package:ad_campaign_dashboard/features/dashboard/model/summary.dart' as dashboard_model;
import 'package:ad_campaign_dashboard/features/dashboard/repository/dashboard_repository.dart';
import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardProvider(this._repository);

  final DashboardRepository _repository;

  ViewState state = ViewState.idle;
  dashboard_model.Summary? summary;
  int selectedDays = 7;
  String? errorMessage;

  Future<void> loadSummary({int? days}) async {
    selectedDays = days ?? selectedDays;
    state = ViewState.loading;
    errorMessage = null;
    notifyListeners();

    final result = await _repository.getSummary(selectedDays);
    switch (result) {
      case Success<dashboard_model.Summary>():
        summary = result.data;
        state = summary == null ? ViewState.empty : ViewState.success;
      case Failure<dashboard_model.Summary>():
        errorMessage = result.message;
        state = ViewState.error;
    }
    notifyListeners();
  }
}
