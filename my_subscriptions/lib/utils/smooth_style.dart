import 'package:flutter/material.dart';

/// Valori standard per [SmoothContainer] dal package `smooth_corner`.
abstract final class SmoothStyle {
  static const double smoothness = 1;
  static final BorderRadius borderRadius = BorderRadius.circular(12);

  /// Bottom sheet: angoli smooth solo in alto.
  static final BorderRadius borderRadiusSheet = BorderRadius.vertical(
    top: Radius.circular(12),
  );
}
