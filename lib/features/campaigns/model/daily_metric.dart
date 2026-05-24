class DailyMetric {
  DailyMetric({required this.date, required this.ctr});

  final DateTime date;
  final double ctr;

  factory DailyMetric.fromJson(Map<String, dynamic> json) {
    return DailyMetric(
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      ctr: (json['ctr'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String().split('T').first,
        'ctr': ctr,
      };
}
