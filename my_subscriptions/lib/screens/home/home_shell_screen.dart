import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/sketch/sketch_screen.dart';
import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/services/user_service.dart';
import 'package:my_subscriptions/utils/colors.dart';
import 'package:my_subscriptions/utils/notification_permission_helper.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.subscriptions_outlined),
            label: 'Abbonamenti',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'Impostazioni',
          ),
        ],
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
      final summary = await getIt<SubscriptionService>().summary();
      if (mounted) {
        setState(() {
          _summary = summary;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SketchScreen(
      showAppBar: true,
      title: 'Home',
      subtitle: 'Panoramica spese e prossimi rinnovi.',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SketchCard(
                  title: 'Spesa mensile',
                  subtitle: _summary == null
                      ? 'Nessun dato'
                      : '${_summary!.monthlyTotal.toStringAsFixed(2)} ${_summary!.currency}',
                ),
                const SizedBox(height: 12),
                SketchCard(
                  title: 'Abbonamenti attivi',
                  subtitle: _summary?.activeCount.toString() ?? '0',
                ),
                const SizedBox(height: 12),
                SketchCard(
                  title: 'Prossimi rinnovi',
                  subtitle: 'Schermata calendario (da implementare)',
                  onTap: () => context.go(AppRoutes.analytics),
                ),
              ],
            ),
      actions: [
        SketchAction(
          label: 'Nuovo abbonamento',
          onPressed: () => context.push(AppRoutes.subscriptionNew),
        ),
      ],
    );
  }
}

class SubscriptionsTabScreen extends StatefulWidget {
  const SubscriptionsTabScreen({super.key});

  @override
  State<SubscriptionsTabScreen> createState() => _SubscriptionsTabScreenState();
}

class _SubscriptionsTabScreenState extends State<SubscriptionsTabScreen> {
  List<SubscriptionItem> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final items = await getIt<SubscriptionService>().list();
      if (mounted) {
        setState(() {
          _items = items;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SketchScreen(
      title: 'Abbonamenti',
      subtitle: 'Lista abbonamenti con filtri e ricerca (UI da completare).',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
          ? Center(
              child: Text(
                'Nessun abbonamento',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _items[index];
                return SketchCard(
                  title: item.name,
                  subtitle:
                      '${item.amount.toStringAsFixed(2)} ${item.currency} · ${item.billingCycle}',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.subscriptionDetail(item.id)),
                );
              },
            ),
      actions: [
        SketchAction(
          label: 'Aggiungi abbonamento',
          onPressed: () => context.push(AppRoutes.subscriptionNew),
        ),
      ],
    );
  }
}

class AnalyticsTabScreen extends StatelessWidget {
  const AnalyticsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SketchScreen(
      title: 'Analytics',
      subtitle: 'Grafici per categoria, trend e calendario rinnovi.',
      body: ListView(
        children: const [
          SketchCard(title: 'Spesa per categoria', subtitle: '/analytics/by-category'),
          SizedBox(height: 12),
          SketchCard(title: 'Top abbonamenti', subtitle: '/analytics/top'),
          SizedBox(height: 12),
          SketchCard(title: 'Confronto mensile', subtitle: '/analytics/month-comparison'),
          SizedBox(height: 12),
          SketchCard(title: 'Calendario rinnovi', subtitle: '/analytics/calendar'),
        ],
      ),
    );
  }
}

class SettingsTabScreen extends StatelessWidget {
  const SettingsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SketchScreen(
      title: 'Impostazioni',
      subtitle: 'Profilo, preferenze, export e logout.',
      body: ListView(
        children: [
          SketchCard(
            title: 'Profilo',
            subtitle: 'PATCH /users/me',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          SketchCard(
            title: 'Preferenze',
            subtitle: 'Valuta, notifiche, tema',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          SketchCard(
            title: 'Export dati',
            subtitle: 'GET /users/me/export',
            onTap: () {},
          ),
        ],
      ),
      actions: [
        SketchAction(
          label: 'Logout',
          isPrimary: false,
          onPressed: () async {
            await getIt<AuthService>().logout();
            if (context.mounted) {
              context.go(AppRoutes.welcome);
            }
          },
        ),
        SketchAction(
          label: 'Elimina account',
          isPrimary: false,
          onPressed: () async {
            await getIt<UserService>().deleteAccount();
            if (context.mounted) {
              context.go(AppRoutes.welcome);
            }
          },
        ),
      ],
    );
  }
}
