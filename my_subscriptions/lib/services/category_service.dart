import 'package:my_subscriptions/models/category/category_item.dart';
import 'package:my_subscriptions/network/api_client.dart';
import 'package:my_subscriptions/network/api_endpoints.dart';

class CategoryService {
  const CategoryService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CategoryItem>> list() async {
    final response = await _apiClient.get<List<dynamic>>(
      ApiEndpoints.categories,
    );
    return response.data!
        .map((item) => CategoryItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<CategoryItem> getDefaultForSubscription() async {
    final categories = await list();
    if (categories.isEmpty) {
      throw Exception('Nessuna categoria disponibile');
    }

    for (final slug in ['other', 'streaming', 'software']) {
      final match = categories.where((category) => category.slug == slug);
      if (match.isNotEmpty) {
        return match.first;
      }
    }

    return categories.first;
  }
}
