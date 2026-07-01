import 'package:flutter/material.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

abstract final class AppDates {
  static String toApiDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  static DateTime parseApiDate(String value) {
    return DateTime.parse(value.split('T').first);
  }

  static String displayDate(BuildContext context, DateTime date) {
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  static String displayApiDate(BuildContext context, String apiDate) {
    return displayDate(context, parseApiDate(apiDate));
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class SketchDatePicker extends StatelessWidget {
  const SketchDatePicker({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.firstDate,
    this.lastDate,
    this.helpText,
  });

  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String? helpText;

  Future<void> _openPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100, 12, 31),
      locale: Localizations.localeOf(context),
      helpText: helpText ?? 'Seleziona data',
      cancelText: 'Annulla',
      confirmText: 'OK',
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formatted = AppDates.displayDate(context, value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openPicker(context),
            borderRadius: SmoothStyle.borderRadius,
            child: SmoothContainer(
              smoothness: SmoothStyle.smoothness,
              borderRadius: SmoothStyle.borderRadius,
              color: colorScheme.surface,
              side: BorderSide(color: colorScheme.outlineVariant),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatted,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
