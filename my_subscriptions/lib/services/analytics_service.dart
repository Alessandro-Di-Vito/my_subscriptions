import 'package:my_subscriptions/models/analytics/analytics_models.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/api_endpoints.dart';

class AnalyticsService {
  const AnalyticsService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CategoryTotal>> byCategory() async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.analyticsByCategory,
    );
    return response.data!
        .map((e) => CategoryTotal.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<TopSubscription>> top({int limit = 5}) async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.analyticsTop,
      queryParameters: {'limit': limit},
    );
    return response.data!
        .map((e) => TopSubscription.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<MonthComparison> monthComparison() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.analyticsMonthComparison,
    );
    return MonthComparison.fromJson(response.data!);
  }

  Future<TrendData> trend({int months = 12}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.analyticsTrend,
      queryParameters: {'months': months},
    );
    return TrendData.fromJson(response.data!);
  }

  Future<CalendarData> calendar({required int year, required int month}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.analyticsCalendar,
      queryParameters: {'year': year, 'month': month},
    );
    return CalendarData.fromJson(response.data!);
  }
}
