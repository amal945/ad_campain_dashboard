class ForecastPoint {
  ForecastPoint({
    required this.date,
    required this.predictedCtr,
    required this.lowerBound,
    required this.upperBound,
  });

  final DateTime date;
  final double predictedCtr;
  final double lowerBound;
  final double upperBound;

  factory ForecastPoint.fromJson(Map<String, dynamic> json) {
    return ForecastPoint(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      predictedCtr: (json['predicted_ctr'] as num?)?.toDouble() ?? 0,
      lowerBound: (json['lower_bound'] as num?)?.toDouble() ?? 0,
      upperBound: (json['upper_bound'] as num?)?.toDouble() ?? 0,
    );
  }
}
