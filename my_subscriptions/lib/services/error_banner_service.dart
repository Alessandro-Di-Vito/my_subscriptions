import 'package:flutter/material.dart' hide Banner;
import 'package:my_subscriptions/components/banner/banner.dart' as app_banner;

class ErrorBannerService {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showError(String message) {
    final messenger = messengerKey.currentState;
    if (messenger == null) {
      return;
    }

    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        content: app_banner.Banner(message: message),
      ),
    );
  }
}
