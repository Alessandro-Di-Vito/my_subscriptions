import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/sketch/sketch_date_picker.dart';

class AppWeekCalendar extends StatelessWidget {
  const AppWeekCalendar({
    required this.selectedDay,
    required this.onDaySelected,
    super.key,
    this.markedDays = const {},
  });

  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final Set<int> markedDays;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final start = selectedDay.subtract(Duration(days: selectedDay.weekday - 1));
    final days = List.generate(7, (i) => start.add(Duration(days: i)));
    const labels = ['L', 'M', 'M', 'G', 'V', 'S', 'D'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final day = days[index];
        final isSelected = AppDates.isSameDay(day, selectedDay);
        final hasMark = markedDays.contains(day.day);

        return GestureDetector(
          onTap: () => onDaySelected(day),
          child: Column(
            children: [
              Text(
                labels[index],
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? scheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${day.day}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? scheme.onPrimary
                            : scheme.onSurface,
                      ),
                    ),
                    if (hasMark && !isSelected)
                      Container(
                        width: 4,
                        height: 4,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class AppMonthCalendar extends StatelessWidget {
  const AppMonthCalendar({
    required this.year,
    required this.month,
    required this.selectedDay,
    required this.onDaySelected,
    super.key,
    this.markedDays = const {},
    this.onPrevious,
    this.onNext,
  });

  final int year;
  final int month;
  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final Set<int> markedDays;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final first = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = first.weekday;
    final monthLabel = _monthName(month);

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                '$monthLabel $year',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['L', 'M', 'M', 'G', 'V', 'S', 'D']
              .map(
                (l) => SizedBox(
                  width: 36,
                  child: Text(
                    l,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: startWeekday - 1 + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
          ),
          itemBuilder: (context, index) {
            if (index < startWeekday - 1) return const SizedBox.shrink();
            final day = index - (startWeekday - 1) + 1;
            final date = DateTime(year, month, day);
            final isSelected = AppDates.isSameDay(date, selectedDay);
            final hasMark = markedDays.contains(day);

            return GestureDetector(
              onTap: () => onDaySelected(date),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? scheme.primary : null,
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? scheme.onPrimary
                            : scheme.onSurface,
                      ),
                    ),
                    if (hasMark && !isSelected)
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _monthName(int month) {
    const names = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre',
    ];
    return names[month - 1];
  }
}
