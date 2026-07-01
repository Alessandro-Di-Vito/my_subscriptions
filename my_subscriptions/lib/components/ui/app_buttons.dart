import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.65,
      child: SmoothSurface(
        onTap: onPressed,
        width: double.infinity,
        height: height,
        borderRadius: SmoothStyle.borderRadiusMedium,
        color: scheme.primary,
        child: Center(
          child: icon != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20, color: scheme.onPrimary),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.label,
    super.key,
    this.onPressed,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;

    return Opacity(
      opacity: enabled ? 1 : 0.65,
      child: SmoothSurface(
        onTap: onPressed,
        width: double.infinity,
        height: height,
        borderRadius: SmoothStyle.borderRadiusMedium,
        color: Colors.transparent,
        side: BorderSide(color: scheme.outline),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class AppTextLink extends StatelessWidget {
  const AppTextLink({required this.label, super.key, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class AppCompactButton extends StatelessWidget {
  const AppCompactButton({
    required this.label,
    super.key,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SmoothSurface(
      onTap: onPressed,
      borderRadius: SmoothStyle.borderRadiusMedium,
      color: scheme.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: scheme.onPrimary),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
