import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/colors.dart';
import 'package:my_subscriptions/utils/font_size.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    required this.text,
    required this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SmoothContainer(
        smoothness: SmoothStyle.smoothness,
        borderRadius: SmoothStyle.borderRadius,
        color: AppColors.primary,
        width: double.infinity,
        height: 54,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: button,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
