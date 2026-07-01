import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/api_endpoints.dart';

class SubscriptionService {
  const SubscriptionService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SubscriptionItem>> list() async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.subscriptions,
    );
    return response.data!
        .map((item) => SubscriptionItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<SubscriptionSummary> summary() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.subscriptionsSummary,
    );
    return SubscriptionSummary.fromJson(response.data!);
  }

  Future<SubscriptionItem> create({
    required String name,
    required double amount,
    required String currency,
    required String billingCycle,
    required String nextRenewalDate,
    required String categoryId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.subscriptions,
      data: {
        'name': name,
        'amount': amount,
        'currency': currency,
        'billingCycle': billingCycle,
        'nextRenewalDate': nextRenewalDate,
        'categoryId': categoryId,
        'status': 'ACTIVE',
        'reminderEnabled': true,
      },
    );
    return SubscriptionItem.fromJson(response.data!);
  }

  Future<SubscriptionItem> getById(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      ApiEndpoints.subscription(id),
    );
    return SubscriptionItem.fromJson(response.data!);
  }
}
