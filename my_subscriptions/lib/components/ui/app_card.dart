import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.borderWidth = 1,
    this.backgroundColor,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SmoothSurface(
      onTap: onTap,
      width: double.infinity,
      borderRadius: borderRadius ?? SmoothStyle.borderRadius,
      color: backgroundColor ?? scheme.surface,
      side: BorderSide(
        color: borderColor ?? scheme.outline.withValues(alpha: 0.5),
        width: borderWidth,
      ),
      padding: padding,
      child: child,
    );
  }
}

class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 14)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class AppSettingsTile extends StatelessWidget {
  const AppSettingsTile({
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.onTap,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppListTile(
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      leading: icon != null
          ? SmoothSurface(
              width: 44,
              height: 44,
              borderRadius: SmoothStyle.borderRadius,
              color: scheme.primaryContainer,
              child: Icon(icon, color: scheme.primary, size: 22),
            )
          : null,
      trailing:
          trailing ?? Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
    );
  }
}
