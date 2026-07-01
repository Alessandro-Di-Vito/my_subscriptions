import 'package:my_subscriptions/data/subscription_presets_local.dart';
import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/models/subscription/subscription_preset.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/api_endpoints.dart';

class SubscriptionService {
  const SubscriptionService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SubscriptionItem>> list({
    String? search,
    String? status,
    String? categoryId,
    String sortBy = 'nextRenewalDate',
    String sortOrder = 'asc',
  }) async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.subscriptions,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status.isNotEmpty) 'status': status,
        if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      },
    );
    return response.data!
        .map((item) => SubscriptionItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<SubscriptionItem>> upcoming({int days = 14}) async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.subscriptionsUpcoming,
      queryParameters: {'days': days},
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

  Future<List<SubscriptionPreset>> presets() async {
    try {
      final response = await _apiClient.get<List<dynamic>>(
        ApiEndpoints.subscriptionsPresets,
        showErrorBanner: false,
      );
      return response.data!
          .map((item) => SubscriptionPreset.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return localSubscriptionPresets;
    }
  }

  Future<SubscriptionItem> create({
    required String name,
    required double amount,
    required String currency,
    required String billingCycle,
    required String nextRenewalDate,
    required String categoryId,
    String? notes,
    String? managementUrl,
    String? iconKey,
    int? customCycleDays,
    int? reminderDays,
    bool reminderEnabled = true,
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
        'reminderEnabled': reminderEnabled,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (managementUrl != null && managementUrl.isNotEmpty)
          'managementUrl': managementUrl,
        if (iconKey != null && iconKey.isNotEmpty) 'iconKey': iconKey,
        if (customCycleDays != null) 'customCycleDays': customCycleDays,
        if (reminderDays != null) 'reminderDays': reminderDays,
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

  Future<SubscriptionItem> update(
    String id, {
    required String name,
    required double amount,
    required String currency,
    required String billingCycle,
    required String nextRenewalDate,
    required String categoryId,
    String? notes,
    String? managementUrl,
    String? iconKey,
    int? customCycleDays,
    int? reminderDays,
    bool? reminderEnabled,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      ApiEndpoints.subscription(id),
      data: {
        'name': name,
        'amount': amount,
        'currency': currency,
        'billingCycle': billingCycle,
        'nextRenewalDate': nextRenewalDate,
        'categoryId': categoryId,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (managementUrl != null && managementUrl.isNotEmpty)
          'managementUrl': managementUrl,
        if (iconKey != null && iconKey.isNotEmpty) 'iconKey': iconKey,
        if (customCycleDays != null) 'customCycleDays': customCycleDays,
        if (reminderDays != null) 'reminderDays': reminderDays,
        if (reminderEnabled != null) 'reminderEnabled': reminderEnabled,
      },
    );
    return SubscriptionItem.fromJson(response.data!);
  }

  Future<void> delete(String id) async {
    await _apiClient.delete<void>(ApiEndpoints.subscription(id));
  }

  Future<SubscriptionItem> cancel(String id) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      ApiEndpoints.subscriptionCancel(id),
    );
    return SubscriptionItem.fromJson(response.data!);
  }

  Future<List<RenewalEvent>> renewals(String id) async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.subscriptionRenewals(id),
    );
    return response.data!
        .map((item) => RenewalEvent.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
