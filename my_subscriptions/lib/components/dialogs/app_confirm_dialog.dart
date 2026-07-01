import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/app_buttons.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';

abstract final class AppConfirmDialog {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Conferma',
    String cancelLabel = 'Annulla',
    bool isDestructive = false,
    IconData? icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) {
        final scheme = Theme.of(context).colorScheme;
        final iconColor =
            isDestructive ? scheme.error : scheme.primary;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: SmoothSurface(
            borderRadius: SmoothStyle.borderRadius,
            color: scheme.surface,
            side: BorderSide(color: scheme.outline.withValues(alpha: 0.45)),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  SmoothSurface(
                    width: 52,
                    height: 52,
                    borderRadius: SmoothStyle.borderRadius,
                    color: iconColor.withValues(alpha: 0.12),
                    child: Icon(icon, color: iconColor, size: 26),
                  ),
                  const SizedBox(height: 16),
                ],
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                AppPrimaryButton(
                  label: confirmLabel,
                  height: 48,
                  backgroundColor: isDestructive ? scheme.error : null,
                  foregroundColor: isDestructive ? scheme.onError : null,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                const SizedBox(height: 10),
                AppSecondaryButton(
                  label: cancelLabel,
                  height: 48,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }
}
