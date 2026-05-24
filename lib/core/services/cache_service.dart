import 'dart:io';

import 'package:hive/hive.dart';

class CacheService {
  static const _campaignsBox = 'campaigns_box';

  Future<void> init() async {
    final hivePath = '${Directory.systemTemp.path}/ad_campaign_dashboard_hive';
    final hiveDir = Directory(hivePath);
    if (!hiveDir.existsSync()) {
      hiveDir.createSync(recursive: true);
    }
    Hive.init(hivePath);
    await Hive.openBox<dynamic>(_campaignsBox);
  }

  Future<void> cacheCampaigns(List<Map<String, dynamic>> campaigns) async {
    final box = Hive.box<dynamic>(_campaignsBox);
    await box.put('list', campaigns);
  }

  List<Map<String, dynamic>> getCachedCampaigns() {
    final box = Hive.box<dynamic>(_campaignsBox);
    final data = box.get('list', defaultValue: <dynamic>[]) as List<dynamic>;
    return data.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }
}
