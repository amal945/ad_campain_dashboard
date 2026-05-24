class Snapshot {
  Snapshot({required this.windowId, required this.metrics});

  final String windowId;
  final List<Map<String, dynamic>> metrics;

  factory Snapshot.fromJson(Map<String, dynamic> json) {
    final metricsRaw = (json['metrics'] as List<dynamic>? ?? <dynamic>[]);
    return Snapshot(
      windowId: json['window_id']?.toString() ?? DateTime.now().toIso8601String(),
      metrics: metricsRaw
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() => {
        'window_id': windowId,
        'metrics': metrics,
      };
}
