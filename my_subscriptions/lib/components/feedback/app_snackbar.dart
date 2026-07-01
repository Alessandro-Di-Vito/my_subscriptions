import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';

abstract final class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final background = isError ? scheme.error : scheme.inverseSurface;
    final foreground = isError ? scheme.onError : scheme.onInverseSurface;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          content: SmoothSurface(
            borderRadius: SmoothStyle.borderRadius,
            color: background,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Text(
              message,
              style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message);

  static void error(BuildContext context, String message) =>
      show(context, message: message, isError: true);
}
