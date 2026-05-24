enum CampaignStatus { active, paused, ended, unknown }

class Campaign {
  Campaign({
    required this.id,
    required this.name,
    required this.status,
    required this.channel,
    required this.spend,
    required this.budget,
    required this.impressions,
    required this.clicks,
    this.startDate,
    this.audience,
    this.objective,
  });

  final String id;
  final String name;
  final CampaignStatus status;
  final String channel;
  final double spend;
  final double budget;
  final int impressions;
  final int clicks;
  final String? startDate;
  final String? audience;
  final String? objective;

  double get ctr => impressions == 0 ? 0 : (clicks / impressions) * 100;
  double get spendProgress => budget == 0 ? 0 : (spend / budget).clamp(0, 1);

  factory Campaign.fromJson(Map<String, dynamic> json) {
    CampaignStatus mapStatus(String? value) {
      switch (value?.toLowerCase()) {
        case 'active':
          return CampaignStatus.active;
        case 'paused':
          return CampaignStatus.paused;
        case 'ended':
          return CampaignStatus.ended;
        default:
          return CampaignStatus.unknown;
      }
    }

    return Campaign(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Untitled campaign',
      status: mapStatus(json['status']?.toString()),
      channel: json['channel']?.toString() ?? 'Unknown',
      spend: (json['spend'] as num?)?.toDouble() ?? 0,
      budget: (json['budget'] as num?)?.toDouble() ?? 0,
      impressions: (json['impressions'] as num?)?.toInt() ?? 0,
      clicks: (json['clicks'] as num?)?.toInt() ?? 0,
      startDate: json['start_date']?.toString(),
      audience: json['audience']?.toString(),
      objective: json['objective']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status.name,
      'channel': channel,
      'spend': spend,
      'budget': budget,
      'impressions': impressions,
      'clicks': clicks,
      'start_date': startDate,
      'audience': audience,
      'objective': objective,
    };
  }
}
