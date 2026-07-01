import 'package:flutter/material.dart';

class AppLogoMark extends StatelessWidget {
  const AppLogoMark({
    super.key,
    this.size = 64,
    this.borderRadius = 16,
  });

  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.layers_rounded,
        color: scheme.onPrimary,
        size: size * 0.5,
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
