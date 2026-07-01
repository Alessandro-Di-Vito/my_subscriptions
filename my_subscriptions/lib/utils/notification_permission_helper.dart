import 'package:my_subscriptions/services/local_notification_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';
import 'package:my_subscriptions/utils/storage.dart';

abstract final class NotificationPermissionHelper {
  static Future<void> requestOnFirstHomeVisit() async {
    final alreadyAsked = await Storage.getNotificationsPermissionAsked();
    if (alreadyAsked) {
      return;
    }

    await Storage.setNotificationsPermissionAsked(true);

    final granted = await getIt<LocalNotificationService>().requestPermissions();
    await Storage.setNotificationsEnabled(granted);

    try {
      final profile = await getIt<UserService>().getProfile(showErrorBanner: false);
      if (profile.preferences != null) {
        await getIt<UserService>().updatePreferences(
          profile.preferences!.copyWith(
            notificationsRenewal: granted,
            notificationsTrial: granted,
          ),
          showErrorBanner: false,
        );
      }
    } catch (_) {
      // User may not be logged in yet; local flag is enough for now.
    }
  }
}
