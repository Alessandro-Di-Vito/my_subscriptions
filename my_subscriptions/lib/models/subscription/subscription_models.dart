class SubscriptionSummary {
  const SubscriptionSummary({
    required this.currency,
    required this.activeCount,
    required this.monthlyTotal,
    required this.annualTotal,
    required this.totalCount,
  });

  final String currency;
  final int activeCount;
  final double monthlyTotal;
  final double annualTotal;
  final int totalCount;

  factory SubscriptionSummary.fromJson(Map<String, dynamic> json) {
    return SubscriptionSummary(
      currency: json['currency'] as String? ?? 'EUR',
      activeCount: json['activeCount'] as int? ?? 0,
      monthlyTotal: (json['monthlyTotal'] as num?)?.toDouble() ?? 0,
      annualTotal: (json['annualTotal'] as num?)?.toDouble() ?? 0,
      totalCount: json['totalCount'] as int? ?? 0,
    );
  }
}

class SubscriptionItem {
  const SubscriptionItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
    required this.billingCycle,
    required this.nextRenewalDate,
    required this.status,
    this.categoryName,
  });

  final String id;
  final String name;
  final double amount;
  final String currency;
  final String billingCycle;
  final String nextRenewalDate;
  final String status;
  final String? categoryName;

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>?;
    return SubscriptionItem(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
      nextRenewalDate: json['nextRenewalDate'] as String,
      status: json['status'] as String? ?? 'ACTIVE',
      categoryName: category?['name'] as String?,
    );
  }
}
