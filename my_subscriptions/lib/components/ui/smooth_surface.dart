import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

/// Superficie arrotondata con smooth corner — base per card, bottoni, input, dialog.
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
    this.clipBehavior = Clip.antiAlias,
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
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? SmoothStyle.borderRadius;
    final content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    Widget surface = SmoothContainer(
      smoothness: smoothness ?? SmoothStyle.smoothness,
      borderRadius: radius,
      color: color ?? Colors.transparent,
      side: side ?? BorderSide.none,
      width: width,
      height: height,
      clipBehavior: clipBehavior,
      child: content,
    );

    if (onTap != null) {
      surface = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: surface,
        ),
      );
    }

    return surface;
  }
}

/// Bordo smooth per bottom sheet e dialog di sistema.
RoundedRectangleBorder smoothSheetShape({BorderRadius? borderRadius}) {
  return SmoothRectangleBorder(
    borderRadius: borderRadius ?? SmoothStyle.borderRadiusSheet,
    smoothness: SmoothStyle.smoothness,
  );
}
