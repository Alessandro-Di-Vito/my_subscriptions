import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class Loader extends StatelessWidget {
  const Loader({
    required this.isLoading,
    required this.child,
    this.message,
    super.key,
  });

  final bool isLoading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.22),
              child: Center(
                child: SmoothContainer(
                  smoothness: SmoothStyle.smoothness,
                  borderRadius: SmoothStyle.borderRadius,
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        if (message != null) ...[
                          const SizedBox(height: 12),
                          Text(message!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
