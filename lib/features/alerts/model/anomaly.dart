enum AnomalySeverity { high, medium }

class Anomaly {
  Anomaly({
    required this.id,
    required this.type,
    required this.campaignName,
    required this.spend,
    required this.expected,
    required this.changePercent,
    required this.timestamp,
  });

  final String id;
  final String type;
  final String campaignName;
  final double spend;
  final double expected;
  final double changePercent;
  final String timestamp;

  AnomalySeverity get severity =>
      changePercent.abs() > 50 ? AnomalySeverity.high : AnomalySeverity.medium;

  factory Anomaly.fromJson(Map<String, dynamic> json) {
    return Anomaly(
      id: json['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
      type: json['type']?.toString() ?? 'Unknown',
      campaignName: json['campaign_name']?.toString() ?? 'Unknown Campaign',
      spend: (json['spend'] as num?)?.toDouble() ?? 0,
      expected: (json['expected'] as num?)?.toDouble() ?? 0,
      changePercent: (json['change_percent'] as num?)?.toDouble() ?? 0,
      timestamp: json['timestamp']?.toString() ?? 'Now',
    );
  }
}
