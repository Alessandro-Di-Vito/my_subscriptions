import 'package:my_subscriptions/network/api_client.dart';

class UserService {
  const UserService(ApiClient apiClient);

  Future<bool> hasCompletedOnboarding({bool showErrorBanner = true}) async {
    return false;
  }
}
