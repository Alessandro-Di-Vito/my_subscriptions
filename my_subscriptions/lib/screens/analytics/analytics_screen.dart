import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/ui/app_animated_appear.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_empty_state.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/components/ui/app_donut_chart.dart';
import 'package:my_subscriptions/components/ui/app_hero_card.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/components/ui/app_section_header.dart';
import 'package:my_subscriptions/components/ui/app_week_calendar.dart';
import 'package:my_subscriptions/models/analytics/analytics_models.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/analytics_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/theme/app_palette.dart';
import 'package:my_subscriptions/theme/app_theme_extension.dart';
import 'package:my_subscriptions/utils/money_format.dart';

class AnalyticsTabScreen extends StatefulWidget {
  const AnalyticsTabScreen({super.key});

  @override
  State<AnalyticsTabScreen> createState() => _AnalyticsTabScreenState();
}

class _AnalyticsTabScreenState extends State<AnalyticsTabScreen> {
  List<CategoryTotal> _byCategory = [];
  List<TopSubscription> _top = [];
  MonthComparison? _comparison;
  TrendData? _trend;
  CalendarData? _calendar;
  bool _loading = true;
  bool _calendarLoading = false;

  late int _calendarYear;
  late int _calendarMonth;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _calendarYear = now.year;
    _calendarMonth = now.month;
    _selectedDay = now;
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final analytics = getIt<AnalyticsService>();
      final results = await Future.wait([
        analytics.byCategory(),
        analytics.top(),
        analytics.monthComparison(),
        analytics.trend(),
        analytics.calendar(year: _calendarYear, month: _calendarMonth),
      ]);

      if (mounted) {
        setState(() {
          _byCategory = results[0] as List<CategoryTotal>;
          _top = results[1] as List<TopSubscription>;
          _comparison = results[2] as MonthComparison;
          _trend = results[3] as TrendData;
          _calendar = results[4] as CalendarData;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _changeCalendarMonth(int delta) async {
    var month = _calendarMonth + delta;
    var year = _calendarYear;
    if (month > 12) {
      month = 1;
      year++;
    } else if (month < 1) {
      month = 12;
      year--;
    }

    setState(() {
      _calendarYear = year;
      _calendarMonth = month;
      _calendarLoading = true;
    });

    try {
      final calendar = await getIt<AnalyticsService>().calendar(
        year: year,
        month: month,
      );
      if (mounted) {
        setState(() {
          _calendar = calendar;
          _calendarLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _calendarLoading = false);
    }
  }

  double get _monthlyTotal =>
      _byCategory.fold(0.0, (sum, c) => sum + c.monthlyTotal);

  List<DonutSegment> _donutSegments(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final palette = [
      scheme.primary,
      isDark ? AppPalette.darkChartYellow : scheme.secondary,
      isDark ? AppPalette.darkChartOrange : context.appTheme.savings,
      scheme.onSurfaceVariant.withValues(alpha: 0.5),
    ];

    if (_byCategory.isEmpty) {
      return [
        DonutSegment(
          label: 'Nessun dato',
          value: 1,
          color: scheme.outline,
        ),
      ];
    }

    return _byCategory.asMap().entries.map((entry) {
      final category = entry.value;
      return DonutSegment(
        label: category.name,
        value: category.monthlyTotal,
        color: _parseColor(category.color) ?? palette[entry.key % palette.length],
      );
    }).toList();
  }

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    try {
      final clean = hex.replaceFirst('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return null;
    }
  }

  Set<int> get _markedDays =>
      _calendar?.days.keys.map(int.parse).toSet() ?? {};

  List<CalendarDayItem> get _selectedDayItems {
    final key = '${_selectedDay.day}';
    return _calendar?.days[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final appTheme = context.appTheme;
    final current = _comparison?.currentMonth;
    final projected = _trend?.projectedMonthlyTotal ?? _monthlyTotal;

    return AppPage(
      title: 'Stats & Insights',
      subtitle: 'Panoramica spese e categorie.',
      onRefresh: _load,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _byCategory.isEmpty && _top.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                AppEmptyState(
                  illustration: AppEmptyIllustration.analytics,
                  title: l10n.emptyNoAnalytics,
                  subtitle: l10n.emptyNoAnalyticsSubtitle,
                ),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  AppAnimatedAppear(
                    child: AppHeroCard(
                  label: 'Questo mese',
                  amount: formatMoney(current?.total ?? projected),
                    badge: _formatDelta(_comparison?.deltaPercent),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppAnimatedAppear(
                    index: 1,
                    child: AppCard(
                  child: Column(
                    children: [
                      AppDonutChart(
                        segments: _donutSegments(context),
                        centerTitle: formatMoneyCompact(current?.total ?? projected),
                        centerSubtitle: 'spesa mensile',
                        size: 190,
                      ),
                      const SizedBox(height: 16),
                      DonutLegend(segments: _donutSegments(context)),
                    ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_comparison != null)
                  AppCard(
                    child: Row(
                      children: [
                        Icon(Icons.trending_up_rounded, color: scheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${current?.count ?? 0} rinnovi questo mese',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Mese scorso: ${formatMoney(_comparison!.previousMonth.total)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatDelta(_comparison!.deltaPercent) ?? '—',
                          style: TextStyle(
                            color: appTheme.savings,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                AppSectionHeader(title: 'Top abbonamenti'),
                const SizedBox(height: 10),
                if (_top.isEmpty)
                  AppEmptyState(
                    illustration: AppEmptyIllustration.analytics,
                    title: l10n.emptyNoAnalytics,
                    subtitle: l10n.emptyNoAnalyticsSubtitle,
                  )
                else
                  ..._top.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppListTile(
                        title: item.name,
                        subtitle: item.category,
                        trailing: Text(
                          formatMoney(item.monthlyEquivalent),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        onTap: () =>
                            context.push(AppRoutes.subscriptionDetail(item.id)),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                AppSectionHeader(title: 'Calendario rinnovi'),
                const SizedBox(height: 10),
                AppCard(
                  child: _calendarLoading
                      ? const Padding(
                          padding: EdgeInsets.all(24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          children: [
                            AppMonthCalendar(
                              year: _calendarYear,
                              month: _calendarMonth,
                              selectedDay: _selectedDay,
                              markedDays: _markedDays,
                              onDaySelected: (day) =>
                                  setState(() => _selectedDay = day),
                              onPrevious: () => _changeCalendarMonth(-1),
                              onNext: () => _changeCalendarMonth(1),
                            ),
                            if (_selectedDayItems.isNotEmpty) ...[
                              const Divider(height: 24),
                              ..._selectedDayItems.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(item.name)),
                                      Text(
                                        formatMoneyCompact(
                                          item.amount,
                                          currency: item.currency,
                                        ),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                if (_trend != null && _trend!.points.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  AppSectionHeader(title: 'Andamento ultimi mesi'),
                  const SizedBox(height: 10),
                  AppCard(
                    child: SizedBox(
                      height: 140,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _trend!.points.map((point) {
                          final max = _trend!.points
                              .map((p) => p.total)
                              .reduce((a, b) => a > b ? a : b);
                          final height = max > 0 ? (point.total / max) * 100 : 0.0;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: height,
                                    decoration: BoxDecoration(
                                      color: scheme.primary,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    point.month.substring(5),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: scheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  String? _formatDelta(double? delta) {
    if (delta == null) return null;
    final sign = delta > 0 ? '+' : '';
    return '$sign${delta.toStringAsFixed(0)}%';
  }
}
