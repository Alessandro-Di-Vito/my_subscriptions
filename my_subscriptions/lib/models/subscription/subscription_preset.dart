class SubscriptionPreset {
  const SubscriptionPreset({
    required this.key,
    required this.name,
    required this.categorySlug,
    required this.defaultAmount,
    required this.currency,
    required this.billingCycle,
    this.color,
    this.managementUrl,
  });

  final String key;
  final String name;
  final String categorySlug;
  final double defaultAmount;
  final String currency;
  final String billingCycle;
  final String? color;
  final String? managementUrl;

  factory SubscriptionPreset.fromJson(Map<String, dynamic> json) {
    return SubscriptionPreset(
      key: json['key'] as String,
      name: json['name'] as String,
      categorySlug: json['categorySlug'] as String,
      defaultAmount: (json['defaultAmount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
      color: json['color'] as String?,
      managementUrl: json['managementUrl'] as String?,
    );
  }
}
