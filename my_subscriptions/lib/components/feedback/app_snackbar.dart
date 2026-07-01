import 'package:flutter/material.dart';

abstract final class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: isError ? colorScheme.onError : colorScheme.onInverseSurface,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? colorScheme.error : colorScheme.inverseSurface,
        ),
      );
  }

  static void success(BuildContext context, String message) => show(context, message: message);

  static void error(BuildContext context, String message) =>
      show(context, message: message, isError: true);
}
