import 'package:flutter/material.dart';

final _primaryColor = '#63A375'.fromHex();
final _primaryDarkColor = '#446653'.fromHex();
final _backgroundColor = '#F7F3EC'.fromHex();
final _surfaceColor = '#FFFFFF'.fromHex();
final _textPrimaryColor = '#26332D'.fromHex();
final _textSecondaryColor = '#6D7A72'.fromHex();
final _grayColor = '#F2F2F2'.fromHex();
final _disabledColor = '#E5E5E5'.fromHex();

abstract final class AppColors {
  static final primary = _primaryColor;
  static final primaryDark = _primaryDarkColor;
  static final background = _backgroundColor;
  static final surface = _surfaceColor;
  static final textPrimary = _textPrimaryColor;
  static final textSecondary = _textSecondaryColor;
  static final gray = _grayColor;
  static final disabledColor = _disabledColor;
}

extension HexColor on String {
  Color fromHex() {
    final buffer = StringBuffer();
    final cleanHex = replaceFirst('#', '');

    if (cleanHex.length == 6) {
      buffer.write('FF');
    }

    buffer.write(cleanHex);
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
