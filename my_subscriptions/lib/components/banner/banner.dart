import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class Banner extends StatelessWidget {
  const Banner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SmoothContainer(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        smoothness: SmoothStyle.smoothness,
        width: double.infinity,
        color: colorScheme.error,
        borderRadius: SmoothStyle.borderRadius,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Row(
            children: [
              Icon(Icons.error, color: colorScheme.onError),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onError,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
