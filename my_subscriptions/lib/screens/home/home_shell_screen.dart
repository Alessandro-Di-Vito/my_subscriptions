import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/subscription/subscription_brand_icon.dart';
import 'package:my_subscriptions/components/sketch/sketch_date_picker.dart';
import 'package:my_subscriptions/components/ui/app_animated_appear.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_empty_state.dart';
import 'package:my_subscriptions/components/ui/app_logo.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/components/ui/app_hero_card.dart';
import 'package:my_subscriptions/components/ui/app_section_header.dart';
import 'package:my_subscriptions/components/ui/app_week_calendar.dart';
import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/analytics_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/theme/app_theme_extension.dart';
import 'package:my_subscriptions/utils/money_format.dart';
import 'package:my_subscriptions/utils/notification_permission_helper.dart';
import 'package:my_subscriptions/utils/subscription_labels.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.subscriptions_outlined),
            selectedIcon: Icon(Icons.subscriptions_rounded),
            label: 'Abbonamenti',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline_rounded),
            selectedIcon: Icon(Icons.pie_chart_rounded),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Impostazioni',
          ),
        ],
        indicatorColor: scheme.primaryContainer,
      ),
    );
  }
}

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  SubscriptionSummary? _summary;
  List<SubscriptionItem> _upcoming = [];
  List<SubscriptionItem> _active = [];
  double? _deltaPercent;
  DateTime _selectedDay = DateTime.now();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationPermissionHelper.requestOnFirstHomeVisit();
    });
  }

  Future<void> _load() async {
    try {
      final subService = getIt<SubscriptionService>();
      final results = await Future.wait([
        subService.summary(),
        subService.upcoming(days: 30),
        subService.list(status: 'ACTIVE'),
      ]);

      double? delta;
      try {
        final comparison = await getIt<AnalyticsService>().monthComparison();
        delta = comparison.deltaPercent;
      } catch (_) {}

      if (mounted) {
        setState(() {
          _summary = results[0] as SubscriptionSummary;
          _upcoming = results[1] as List<SubscriptionItem>;
          _active = (results[2] as List<SubscriptionItem>).take(5).toList();
          _deltaPercent = delta;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openNew() async {
    final created = await context.push<bool>(AppRoutes.subscriptionNew);
    if (created == true) await _load();
  }

  Set<int> get _markedDays {
    final now = _selectedDay;
    final start = now.subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 6));
    return _upcoming
        .map((item) => AppDates.parseApiDate(item.nextRenewalDate))
        .where((date) => !date.isBefore(start) && !date.isAfter(end))
        .map((date) => date.day)
        .toSet();
  }

  String? _deltaBadge() {
    final delta = _deltaPercent;
    if (delta == null) return null;
    final sign = delta > 0 ? '+' : '';
    return '$sign${delta.toStringAsFixed(0)}% vs mese scorso';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final appTheme = context.appTheme;
    final featured = _upcoming.isNotEmpty ? _upcoming.first : null;
    final nextRenewal = _upcoming.isNotEmpty
        ? AppDates.parseApiDate(_upcoming.first.nextRenewalDate)
        : null;
    final hasNoData = (_summary?.activeCount ?? 0) == 0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: SmoothSurface(
        onTap: _openNew,
        borderRadius: SmoothStyle.borderRadius,
        color: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: scheme.onPrimary),
            const SizedBox(width: 8),
            Text(
              l10n.addSubscription,
              style: TextStyle(
                color: scheme.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _load,
                color: scheme.primary,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 88),
                  children: [
                    AppAnimatedAppear(
                      child: Row(
                        children: [
                          const AppLogoMark(size: 40),
                          const SizedBox(width: 12),
                          const Expanded(child: AppLogoTitle(compact: true)),
                          IconButton(
                            onPressed: _load,
                            icon: const Icon(Icons.refresh_rounded),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    AppAnimatedAppear(
                      index: 1,
                      child: AppHeroCard(
                        label: 'Spesa mensile totale',
                        amount: _summary == null
                            ? '—'
                            : formatMoney(
                                _summary!.monthlyTotal,
                                currency: _summary!.currency,
                              ),
                        badge: _deltaBadge(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppAnimatedAppear(
                      index: 2,
                      child: AppCard(
                        child: AppWeekCalendar(
                          selectedDay: _selectedDay,
                          markedDays: _markedDays,
                          onDaySelected: (day) =>
                              setState(() => _selectedDay = day),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (hasNoData)
                      AppAnimatedAppear(
                        index: 3,
                        child: AppEmptyState(
                          illustration: AppEmptyIllustration.subscriptions,
                          title: l10n.emptyNoSubscriptions,
                          subtitle: l10n.emptyNoSubscriptionsSubtitle,
                          actionLabel: l10n.addSubscription,
                          onAction: _openNew,
                        ),
                      )
                    else ...[
                      if (featured != null) ...[
                        AppAnimatedAppear(
                          index: 3,
                          child: Text(
                            'Scadenze imminenti',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(height: 10),
                        AppAnimatedAppear(
                          index: 4,
                          child: AppFeaturedSubscriptionCard(
                            name: featured.name,
                            dueLabel: _dueLabel(featured.nextRenewalDate),
                            amount: formatMoneyCompact(
                              featured.amount,
                              currency: featured.currency,
                            ),
                            leading: SubscriptionBrandAvatar(
                              iconKey: featured.iconKey,
                              name: featured.name,
                              size: 44,
                            ),
                            onDetails: () => context.push(
                              AppRoutes.subscriptionDetail(featured.id),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ] else
                        AppAnimatedAppear(
                          index: 3,
                          child: AppCard(
                            child: AppEmptyState(
                              illustration: AppEmptyIllustration.calendar,
                              title: l10n.emptyNoUpcoming,
                              subtitle: l10n.emptyNoUpcomingSubtitle,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      AppAnimatedAppear(
                        index: 5,
                        child: Row(
                          children: [
                            Expanded(
                              child: AppStatTile(
                                icon: Icons.calendar_today_outlined,
                                label: 'Prossimo rinnovo',
                                value: nextRenewal == null
                                    ? '—'
                                    : AppDates.displayDate(
                                        context,
                                        nextRenewal,
                                      ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: AppStatTile(
                                icon: Icons.savings_outlined,
                                label: 'Abbonamenti attivi',
                                value: '${_summary?.activeCount ?? 0}',
                                valueColor: appTheme.savings,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppAnimatedAppear(
                        index: 6,
                        child: AppSectionHeader(
                          title: 'Abbonamenti attivi',
                          actionLabel: 'Vedi tutti',
                          onAction: () => context.go(AppRoutes.subscriptions),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_active.isEmpty)
                        AppAnimatedAppear(
                          index: 7,
                          child: AppEmptyState(
                            illustration: AppEmptyIllustration.subscriptions,
                            title: l10n.emptyNoActive,
                          ),
                        )
                      else
                        ..._active.asMap().entries.map(
                          (entry) => AppAnimatedAppear(
                            index: 7 + entry.key,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AppListTile(
                                leading: SubscriptionBrandAvatar(
                                  iconKey: entry.value.iconKey,
                                  name: entry.value.name,
                                  size: 40,
                                ),
                                title: entry.value.name,
                                subtitle:
                                    '${billingCycleLabel(entry.value.billingCycle)} · '
                                    '${AppDates.displayApiDate(context, entry.value.nextRenewalDate)}',
                                trailing: Text(
                                  formatMoneyCompact(
                                    entry.value.amount,
                                    currency: entry.value.currency,
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                                onTap: () => context.push(
                                  AppRoutes.subscriptionDetail(entry.value.id),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  String _dueLabel(String apiDate) {
    final date = AppDates.parseApiDate(apiDate);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final days = target.difference(today).inDays;
    if (days == 0) return 'Oggi';
    if (days == 1) return 'Domani';
    if (days > 0) return 'Tra $days giorni';
    return 'Scaduto';
  }
}
