class CategoryTotal {
  const CategoryTotal({
    required this.categoryId,
    required this.name,
    this.color,
    required this.monthlyTotal,
  });

  final String categoryId;
  final String name;
  final String? color;
  final double monthlyTotal;

  factory CategoryTotal.fromJson(Map<String, dynamic> json) {
    return CategoryTotal(
      categoryId: json['categoryId'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
      monthlyTotal: (json['monthlyTotal'] as num).toDouble(),
    );
  }
}

class TopSubscription {
  const TopSubscription({
    required this.id,
    required this.name,
    required this.category,
    required this.monthlyEquivalent,
  });

  final String id;
  final String name;
  final String category;
  final double monthlyEquivalent;

  factory TopSubscription.fromJson(Map<String, dynamic> json) {
    return TopSubscription(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      monthlyEquivalent: (json['monthlyEquivalent'] as num).toDouble(),
    );
  }
}

class MonthComparison {
  const MonthComparison({
    required this.currentMonth,
    required this.previousMonth,
    this.deltaPercent,
  });

  final MonthBucket currentMonth;
  final MonthBucket previousMonth;
  final double? deltaPercent;

  factory MonthComparison.fromJson(Map<String, dynamic> json) {
    return MonthComparison(
      currentMonth: MonthBucket.fromJson(
        json['currentMonth'] as Map<String, dynamic>,
      ),
      previousMonth: MonthBucket.fromJson(
        json['previousMonth'] as Map<String, dynamic>,
      ),
      deltaPercent: (json['deltaPercent'] as num?)?.toDouble(),
    );
  }
}

class MonthBucket {
  const MonthBucket({
    required this.from,
    required this.to,
    required this.total,
    required this.count,
  });

  final String from;
  final String to;
  final double total;
  final int count;

  factory MonthBucket.fromJson(Map<String, dynamic> json) {
    return MonthBucket(
      from: json['from'] as String,
      to: json['to'] as String,
      total: (json['total'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}

class TrendData {
  const TrendData({
    required this.points,
    required this.projectedMonthlyTotal,
    this.note,
  });

  final List<TrendPoint> points;
  final double projectedMonthlyTotal;
  final String? note;

  factory TrendData.fromJson(Map<String, dynamic> json) {
    return TrendData(
      points: (json['points'] as List<dynamic>)
          .map((e) => TrendPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      projectedMonthlyTotal: (json['projectedMonthlyTotal'] as num).toDouble(),
      note: json['note'] as String?,
    );
  }
}

class TrendPoint {
  const TrendPoint({required this.month, required this.total});

  final String month;
  final double total;

  factory TrendPoint.fromJson(Map<String, dynamic> json) {
    return TrendPoint(
      month: json['month'] as String,
      total: (json['total'] as num).toDouble(),
    );
  }
}

class CalendarData {
  const CalendarData({
    required this.year,
    required this.month,
    required this.days,
  });

  final int year;
  final int month;
  final Map<String, List<CalendarDayItem>> days;

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    final rawDays = json['days'] as Map<String, dynamic>? ?? {};
    return CalendarData(
      year: json['year'] as int,
      month: json['month'] as int,
      days: rawDays.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => CalendarDayItem.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      ),
    );
  }
}

class CalendarDayItem {
  const CalendarDayItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.currency,
  });

  final String id;
  final String name;
  final double amount;
  final String currency;

  factory CalendarDayItem.fromJson(Map<String, dynamic> json) {
    return CalendarDayItem(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'EUR',
    );
  }
}
