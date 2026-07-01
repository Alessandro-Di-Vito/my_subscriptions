import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/sketch/sketch_screen.dart';
import 'package:my_subscriptions/models/subscription/subscription_models.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  const SubscriptionDetailScreen({required this.subscriptionId, super.key});

  final String subscriptionId;

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  SubscriptionItem? _item;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final item = await getIt<SubscriptionService>().getById(
        widget.subscriptionId,
      );
      if (mounted) {
        setState(() {
          _item = item;
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
      title: 'Dettaglio abbonamento',
      subtitle: _item == null
          ? 'Caricamento...'
          : '${_item!.name} · ${_item!.status}',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _item == null
          ? const Center(child: Text('Abbonamento non trovato'))
          : ListView(
              children: [
                SketchCard(
                  title: 'Importo',
                  subtitle:
                      '${_item!.amount.toStringAsFixed(2)} ${_item!.currency}',
                ),
                const SizedBox(height: 12),
                SketchCard(
                  title: 'Ciclo',
                  subtitle: _item!.billingCycle,
                ),
                const SizedBox(height: 12),
                SketchCard(
                  title: 'Prossimo rinnovo',
                  subtitle: _item!.nextRenewalDate,
                ),
                const SizedBox(height: 12),
                const SketchCard(
                  title: 'Storico rinnovi',
                  subtitle: 'GET /subscriptions/:id/renewals',
                ),
              ],
            ),
      actions: [
        SketchAction(
          label: 'Modifica',
          onPressed: _item == null
              ? null
              : () => context.push(
                  AppRoutes.subscriptionEdit(widget.subscriptionId),
                ),
        ),
      ],
    );
  }
}

class SubscriptionFormScreen extends StatelessWidget {
  const SubscriptionFormScreen({super.key, this.subscriptionId});

  final String? subscriptionId;

  bool get isEdit => subscriptionId != null;

  @override
  Widget build(BuildContext context) {
    return SketchScreen(
      title: isEdit ? 'Modifica abbonamento' : 'Nuovo abbonamento',
      subtitle: isEdit
          ? 'PATCH /subscriptions/$subscriptionId'
          : 'POST /subscriptions',
      body: ListView(
        children: [
          SketchField(label: 'Nome'),
          SizedBox(height: 16),
          SketchField(label: 'Importo'),
          SizedBox(height: 16),
          SketchField(label: 'Valuta'),
          SizedBox(height: 16),
          SketchField(label: 'Ciclo di fatturazione'),
          SizedBox(height: 16),
          SketchField(label: 'Prossimo rinnovo'),
          SizedBox(height: 16),
          SketchField(label: 'Categoria'),
        ],
      ),
      actions: [
        SketchAction(
          label: 'Salva (placeholder)',
          onPressed: () => context.pop(),
        ),
      ],
    );
  }
}
