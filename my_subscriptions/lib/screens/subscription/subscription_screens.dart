import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/dialogs/subscription_dialogs.dart';
import 'package:my_subscriptions/components/sketch/sketch_date_picker.dart';
import 'package:my_subscriptions/components/subscription/subscription_brand_icon.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_empty_state.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/utils/money_format.dart';
import 'package:my_subscriptions/utils/subscription_labels.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  const SubscriptionDetailScreen({required this.subscriptionId, super.key});

  final String subscriptionId;

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  SubscriptionItem? _item;
  List<RenewalEvent> _renewals = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final service = getIt<SubscriptionService>();
      final results = await Future.wait([
        service.getById(widget.subscriptionId),
        service.renewals(widget.subscriptionId),
      ]);
      if (mounted) {
        setState(() {
          _item = results[0] as SubscriptionItem;
          _renewals = results[1] as List<RenewalEvent>;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _cancel() async {
    if (await SubscriptionDialogs.confirmCancel(context) && mounted) {
      await getIt<SubscriptionService>().cancel(widget.subscriptionId);
      await _load();
    }
  }

  Future<void> _delete() async {
    final item = _item;
    if (item == null) return;

    if (await SubscriptionDialogs.confirmDelete(
          context,
          subscriptionName: item.name,
        ) &&
        mounted) {
      await getIt<SubscriptionService>().delete(widget.subscriptionId);
      if (mounted) context.pop(true);
    }
  }

  Future<void> _openManagementUrl() async {
    final url = _item?.managementUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isActive = item?.status == 'ACTIVE' || item?.status == 'TRIAL';

    return AppPage(
      title: 'Dettaglio',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : item == null
          ? const Center(child: Text('Abbonamento non trovato'))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                AppCard(
                  child: Row(
                    children: [
                      SubscriptionBrandAvatar(
                        iconKey: item.iconKey,
                        name: item.name,
                        size: 56,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Stato: ${statusLabel(item.status)}',
                              style: TextStyle(
                                color: isActive
                                    ? scheme.primary
                                    : scheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  formatMoneyCompact(item.amount, currency: item.currency),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  billingCycleLabel(item.billingCycle),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Prossimo rinnovo',
                  value: AppDates.displayApiDate(context, item.nextRenewalDate),
                ),
                const SizedBox(height: 10),
                _InfoRow(
                  icon: Icons.category_outlined,
                  label: 'Categoria',
                  value: item.categoryName ?? '—',
                ),
                if (item.notes != null && item.notes!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.notes_outlined,
                    label: 'Note',
                    value: item.notes!,
                  ),
                ],
                if (item.managementUrl != null &&
                    item.managementUrl!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  AppListTile(
                    title: 'Gestione online',
                    subtitle: item.managementUrl,
                    leading: Icon(Icons.open_in_new, color: scheme.primary),
                    onTap: _openManagementUrl,
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Storico pagamenti',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                if (_renewals.isEmpty)
                  AppEmptyState(
                    illustration: AppEmptyIllustration.calendar,
                    title: l10n.emptyNoRenewals,
                  )
                else
                  AppCard(
                    child: Column(
                      children: _renewals.map((renewal) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              SmoothSurface(
                                width: 8,
                                height: 8,
                                borderRadius: BorderRadius.circular(4),
                                color: scheme.primary,
                                child: const SizedBox.shrink(),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  AppDates.displayApiDate(context, renewal.date),
                                ),
                              ),
                              Text(
                                formatMoneyCompact(
                                  renewal.amount,
                                  currency: renewal.currency,
                                ),
                                style: const TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
      actions: [
        AppPageAction(
          label: 'Modifica',
          onPressed: item == null
              ? null
              : () async {
                  final updated = await context.push<bool>(
                    AppRoutes.subscriptionEdit(widget.subscriptionId),
                  );
                  if (updated == true) await _load();
                },
        ),
        if (item != null && item.status != 'CANCELLED')
          AppPageAction(
            label: 'Segna come cancellato',
            isPrimary: false,
            onPressed: _cancel,
          ),
        AppPageAction(
          label: 'Elimina',
          isPrimary: false,
          onPressed: item == null ? null : _delete,
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: scheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
