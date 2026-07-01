import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

/// Wrapper su [SmoothContainer] (`smooth_corner`) per card, input, dialog.
class SmoothSurface extends StatelessWidget {
  const SmoothSurface({
    required this.child,
    super.key,
    this.color,
    this.borderRadius,
    this.smoothness,
    this.side,
    this.width,
    this.height,
    this.padding,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final BorderRadius? borderRadius;
  final double? smoothness;
  final BorderSide? side;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? SmoothStyle.borderRadius;

    Widget surface = SmoothContainer(
      smoothness: smoothness ?? SmoothStyle.smoothness,
      borderRadius: radius,
      color: color ?? Colors.transparent,
      side: side ?? BorderSide.none,
      width: width,
      height: height,
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      surface = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: surface,
      );
    }

    return surface;
  }
}

/// Bordo smooth per bottom sheet.
ShapeBorder smoothSheetShape({BorderRadius? borderRadius}) {
  return SmoothRectangleBorder(
    borderRadius: borderRadius ?? SmoothStyle.borderRadiusSheet,
    smoothness: SmoothStyle.smoothness,
  );
}
