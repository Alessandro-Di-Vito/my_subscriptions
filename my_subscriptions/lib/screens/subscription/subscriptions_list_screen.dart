import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/dialogs/subscription_dialogs.dart';
import 'package:my_subscriptions/components/subscription/subscription_brand_icon.dart';
import 'package:my_subscriptions/components/ui/app_animated_appear.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:my_subscriptions/components/ui/app_empty_state.dart';
import 'package:my_subscriptions/components/ui/app_fields.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/utils/money_format.dart';
import 'package:my_subscriptions/utils/subscription_labels.dart';

class SubscriptionsTabScreen extends StatefulWidget {
  const SubscriptionsTabScreen({super.key});

  @override
  State<SubscriptionsTabScreen> createState() => _SubscriptionsTabScreenState();
}

class _SubscriptionsTabScreenState extends State<SubscriptionsTabScreen> {
  final _searchController = TextEditingController();
  List<SubscriptionItem> _items = [];
  String? _statusFilter;
  bool _loading = true;

  static const _statuses = ['ACTIVE', 'TRIAL', 'PAUSED', 'CANCELLED'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final items = await getIt<SubscriptionService>().list(
        search: _searchController.text.trim(),
        status: _statusFilter,
      );
      if (mounted) {
        setState(() {
          _items = items;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Abbonamenti',
      subtitle: 'Gestisci tutti i tuoi servizi ricorrenti.',
      onRefresh: _load,
      floatingActionButton: FloatingActionButton(
        onPressed: _openNew,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                AppField(
                  label: 'Cerca',
                  controller: _searchController,
                  hint: 'Netflix, Spotify...',
                  prefixIcon: Icons.search,
                  suffixIcon: IconButton(
                    onPressed: _load,
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                AppDropdownField<String?>(
                  label: 'Stato',
                  value: _statusFilter,
                  items: [null, ..._statuses],
                  itemLabel: (v) => v == null ? 'Tutti' : statusLabel(v),
                  prefixIcon: Icons.filter_list_rounded,
                  onChanged: (value) {
                    setState(() => _statusFilter = value);
                    _load();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _items.isEmpty
                ? AppEmptyState(
                    illustration: AppEmptyIllustration.subscriptions,
                    title: l10n.emptyNoSubscriptions,
                    subtitle: l10n.emptyNoSubscriptionsSubtitle,
                    actionLabel: l10n.addSubscription,
                    onAction: _openNew,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: _items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return AppAnimatedAppear(
                          index: index,
                          child: Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                          background: SmoothSurface(
                            borderRadius: SmoothStyle.borderRadius,
                            color: scheme.error,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete, color: Colors.white),
                            ),
                          ),
                        confirmDismiss: (_) {
                          return SubscriptionDialogs.confirmDelete(
                            context,
                            subscriptionName: item.name,
                          );
                        },
                        onDismissed: (_) async {
                          await getIt<SubscriptionService>().delete(item.id);
                          await _load();
                        },
                        child: AppListTile(
                          leading: SubscriptionBrandAvatar(
                            iconKey: item.iconKey,
                            name: item.name,
                            size: 44,
                          ),
                          title: item.name,
                          subtitle:
                              '${formatMoneyCompact(item.amount, currency: item.currency)} · '
                              '${billingCycleLabel(item.billingCycle)} · '
                              '${statusLabel(item.status)}',
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () async {
                            await context.push(
                              AppRoutes.subscriptionDetail(item.id),
                            );
                            await _load();
                          },
                        ),
                          ),
                        );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
