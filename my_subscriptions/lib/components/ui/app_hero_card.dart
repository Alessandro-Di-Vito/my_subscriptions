import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/theme/app_theme_extension.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AppHeroCard extends StatelessWidget {
  const AppHeroCard({
    required this.label,
    required this.amount,
    super.key,
    this.badge,
    this.trailing,
  });

  final String label;
  final String amount;
  final String? badge;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;

    return SmoothClipRRect(
      smoothness: SmoothStyle.smoothness,
      borderRadius: SmoothStyle.borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              appTheme.heroGradientStart,
              appTheme.heroGradientEnd,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (trailing != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [trailing!],
                ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      amount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                  ),
                  if (badge != null)
                    SmoothContainer(
                      smoothness: SmoothStyle.smoothness,
                      borderRadius: SmoothStyle.borderRadius,
                      color: Colors.white.withValues(alpha: 0.15),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppStatTile extends StatelessWidget {
  const AppStatTile({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: scheme.primary),
          const SizedBox(height: 10),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor ?? scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
