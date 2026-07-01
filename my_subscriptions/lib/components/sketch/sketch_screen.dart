import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/button/button_widget.dart';
import 'package:my_subscriptions/utils/colors.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SketchScreen extends StatelessWidget {
  const SketchScreen({
    required this.title,
    super.key,
    this.subtitle,
    this.body,
    this.actions = const [],
    this.showAppBar = true,
  });

  final String title;
  final String? subtitle;
  final Widget? body;
  final List<SketchAction> actions;
  final bool showAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: showAppBar ? AppBar(title: Text(title)) : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (body != null) Expanded(child: body!),
              if (body == null) const Spacer(),
              ...actions.map(
                (action) => Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: action.isPrimary
                      ? ButtonWidget(
                          text: action.label,
                          onPressed: action.onPressed,
                        )
                      : ButtonWidget(
                          text: action.label,
                          onPressed: action.onPressed,
                          backgroundColor: Colors.transparent,
                          textColor: AppColors.textPrimary,
                          borderColor: AppColors.gray,
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

class SketchAction {
  const SketchAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
}

class SketchCard extends StatelessWidget {
  const SketchCard({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SmoothContainer(
        smoothness: SmoothStyle.smoothness,
        borderRadius: SmoothStyle.borderRadius,
        color: AppColors.surface,
        side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.12)),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class SketchField extends StatelessWidget {
  const SketchField({
    required this.label,
    super.key,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SmoothContainer(
          smoothness: SmoothStyle.smoothness,
          borderRadius: SmoothStyle.borderRadius,
          color: AppColors.surface,
          side: BorderSide(color: AppColors.textSecondary.withValues(alpha: 0.12)),
          width: double.infinity,
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
