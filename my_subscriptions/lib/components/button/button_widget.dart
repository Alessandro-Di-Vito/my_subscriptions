import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/font_size.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isEnabled = onPressed != null;
    final isSecondary = backgroundColor == Colors.transparent;

    final Color fillColor;
    final Color labelColor;
    final Color border;

    if (!isEnabled) {
      fillColor = scheme.surfaceContainerHighest;
      labelColor = scheme.onSurfaceVariant;
      border = borderColor ?? scheme.outline;
    } else if (isSecondary) {
      fillColor = Colors.transparent;
      labelColor = textColor ?? scheme.primary;
      border = borderColor ?? scheme.outline;
    } else {
      fillColor = backgroundColor ?? scheme.primary;
      labelColor = textColor ?? scheme.onPrimary;
      border = borderColor ?? fillColor;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: isEnabled ? 1 : 0.65,
        child: SmoothContainer(
          smoothness: SmoothStyle.smoothness,
          borderRadius: SmoothStyle.borderRadius,
          color: fillColor,
          side: BorderSide(color: border),
          width: double.infinity,
          height: 54,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: labelColor,
                fontSize: button,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
