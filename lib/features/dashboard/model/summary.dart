class Summary {
  Summary({
    required this.totalSpend,
    required this.channelSpend,
    required this.topCampaignsByCtr,
  });

  final double totalSpend;
  final Map<String, double> channelSpend;
  final List<SummaryCampaign> topCampaignsByCtr;

  factory Summary.fromJson(Map<String, dynamic> json) {
    final channelSpend = <String, double>{};
    final byChannel = json['by_channel'] as List<dynamic>?;
    if (byChannel != null) {
      for (final item in byChannel) {
        final map = Map<String, dynamic>.from(item as Map);
        final name = map['channel']?.toString() ?? 'Unknown';
        final spend = (map['spend'] as num?)?.toDouble() ?? 0;
        channelSpend[name] = spend;
      }
    } else {
      final channelRaw = Map<String, dynamic>.from(
        json['channel_spend'] as Map? ?? <String, dynamic>{},
      );
      channelRaw.forEach((key, value) {
        channelSpend[key] = (value as num?)?.toDouble() ?? 0;
      });
    }
    final topRaw = (json['top_campaigns'] as List<dynamic>? ?? <dynamic>[]);
    return Summary(
      totalSpend: (json['total_spend'] as num?)?.toDouble() ?? 0,
      channelSpend: channelSpend,
      topCampaignsByCtr: topRaw
          .map((item) => SummaryCampaign.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
    );
  }
}

class SummaryCampaign {
  SummaryCampaign({required this.name, required this.ctr});

  final String name;
  final double ctr;

  factory SummaryCampaign.fromJson(Map<String, dynamic> json) {
    return SummaryCampaign(
      name: json['name']?.toString() ?? 'Unknown campaign',
      ctr: (json['ctr'] as num?)?.toDouble() ?? 0,
    );
  }
}
