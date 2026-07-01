import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({
    super.key,
    this.size = 64,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SmoothContainer(
        width: size,
        height: size,
        smoothness: SmoothStyle.smoothness,
        borderRadius: SmoothStyle.borderRadius,
        color: scheme.primary,
        child: Icon(
          Icons.layers_rounded,
          color: scheme.onPrimary,
          size: size * 0.5,
        ),
      ),
    );
  }
}

class AppLogoTitle extends StatelessWidget {
  const AppLogoTitle({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Text(
      'MySubscriptions',
      style: (compact
              ? Theme.of(context).textTheme.titleLarge
              : Theme.of(context).textTheme.headlineSmall)
          ?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}
