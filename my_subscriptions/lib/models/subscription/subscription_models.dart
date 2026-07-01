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
    this.categoryId,
    this.categoryName,
    this.notes,
    this.managementUrl,
    this.customCycleDays,
    this.reminderDays,
    this.reminderEnabled = true,
    this.iconKey,
  });

  final String id;
  final String name;
  final double amount;
  final String currency;
  final String billingCycle;
  final String nextRenewalDate;
  final String status;
  final String? categoryId;
  final String? categoryName;
  final String? notes;
  final String? managementUrl;
  final int? customCycleDays;
  final int? reminderDays;
  final bool reminderEnabled;
  final String? iconKey;

  factory SubscriptionItem.fromJson(Map<String, dynamic> json) {
    final category = json['category'] as Map<String, dynamic>?;
    return SubscriptionItem(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
      billingCycle: json['billingCycle'] as String? ?? 'MONTHLY',
      nextRenewalDate: json['nextRenewalDate'] is String
          ? json['nextRenewalDate'] as String
          : (json['nextRenewalDate'] as DateTime).toIso8601String().split('T').first,
      status: json['status'] as String? ?? 'ACTIVE',
      categoryId: json['categoryId'] as String? ?? category?['id'] as String?,
      categoryName: category?['name'] as String?,
      notes: json['notes'] as String?,
      managementUrl: json['managementUrl'] as String?,
      customCycleDays: json['customCycleDays'] as int?,
      reminderDays: json['reminderDays'] as int?,
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      iconKey: json['iconKey'] as String?,
    );
  }

  Map<String, dynamic> toCreateJson({
    required String categoryId,
  }) {
    return {
      'name': name,
      'amount': amount,
      'currency': currency,
      'billingCycle': billingCycle,
      'nextRenewalDate': nextRenewalDate,
      'categoryId': categoryId,
      'status': status,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (managementUrl != null && managementUrl!.isNotEmpty)
        'managementUrl': managementUrl,
      if (customCycleDays != null) 'customCycleDays': customCycleDays,
      'reminderEnabled': reminderEnabled,
      if (reminderDays != null) 'reminderDays': reminderDays,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'amount': amount,
      'currency': currency,
      'billingCycle': billingCycle,
      'nextRenewalDate': nextRenewalDate,
      if (categoryId != null) 'categoryId': categoryId,
      if (notes != null) 'notes': notes,
      if (managementUrl != null) 'managementUrl': managementUrl,
      if (customCycleDays != null) 'customCycleDays': customCycleDays,
      'reminderEnabled': reminderEnabled,
      if (reminderDays != null) 'reminderDays': reminderDays,
    };
  }
}

class RenewalEvent {
  const RenewalEvent({
    required this.id,
    required this.date,
    required this.amount,
    required this.currency,
  });

  final String id;
  final String date;
  final double amount;
  final String currency;

  factory RenewalEvent.fromJson(Map<String, dynamic> json) {
    return RenewalEvent(
      id: json['id'] as String,
      date: json['date'] is String
          ? json['date'] as String
          : (json['date'] as DateTime).toIso8601String().split('T').first,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
    );
  }
}
