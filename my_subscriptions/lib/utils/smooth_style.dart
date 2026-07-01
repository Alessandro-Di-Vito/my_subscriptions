import 'package:flutter/material.dart';

abstract final class SmoothStyle {
  static const double smoothness = 1;

  static final BorderRadius borderRadius = BorderRadius.circular(12);
  static final BorderRadius borderRadiusMedium = BorderRadius.circular(14);
  static final BorderRadius borderRadiusLarge = BorderRadius.circular(16);
  static final BorderRadius borderRadiusXLarge = BorderRadius.circular(20);
  static final BorderRadius borderRadiusSheet = BorderRadius.vertical(
    top: Radius.circular(20),
  );
  static final BorderRadius borderRadiusDialog = BorderRadius.circular(20);
  static final BorderRadius borderRadiusPill = BorderRadius.circular(999);
}
