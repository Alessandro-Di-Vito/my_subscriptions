import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/sketch/sketch_date_picker.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';

class AppField extends StatelessWidget {
  const AppField({
    required this.label,
    super.key,
    this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController? controller;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SmoothSurface(
          width: double.infinity,
          borderRadius: SmoothStyle.borderRadius,
          color: scheme.surface,
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    super.key,
    this.prefixIcon,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: scheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        SmoothSurface(
          width: double.infinity,
          borderRadius: SmoothStyle.borderRadius,
          color: scheme.surface,
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              isExpanded: true,
              items: items
                  .map(
                    (item) => DropdownMenuItem<T>(
                      value: item,
                      child: Text(itemLabel(item)),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class AppDateField extends StatelessWidget {
  const AppDateField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.helpText,
    this.firstDate,
    this.lastDate,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final String? helpText;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return SketchDatePicker(
      label: label,
      value: value,
      helpText: helpText ?? 'Seleziona una data',
      firstDate: firstDate ?? DateTime(2020),
      lastDate: lastDate ?? DateTime(2035),
      onChanged: onChanged,
    );
  }
}

class AppCategoryChips extends StatelessWidget {
  const AppCategoryChips({
    required this.items,
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final List<({String id, String name, IconData icon})> items;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = item.id == selectedId;

          return SmoothSurface(
            onTap: () => onSelected(item.id),
            borderRadius: SmoothStyle.borderRadius,
            color: selected ? scheme.primaryContainer : scheme.surface,
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outline,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 16,
                  color: selected
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  item.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? scheme.onPrimaryContainer
                        : scheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

IconData categoryIconForSlug(String? slug) {
  return switch (slug) {
    'entertainment' => Icons.movie_outlined,
    'music' => Icons.music_note_outlined,
    'productivity' => Icons.work_outline,
    'cloud' => Icons.cloud_outlined,
    'gaming' => Icons.sports_esports_outlined,
    'fitness' => Icons.fitness_center_outlined,
    'news' => Icons.newspaper_outlined,
    'security' => Icons.shield_outlined,
    'food' => Icons.restaurant_outlined,
    _ => Icons.category_outlined,
  };
}
