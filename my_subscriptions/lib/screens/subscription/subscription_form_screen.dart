import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/sketch/sketch_date_picker.dart';
import 'package:my_subscriptions/components/subscription/subscription_preset_field.dart';
import 'package:my_subscriptions/components/ui/app_fields.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/models/category/category_item.dart';
import 'package:my_subscriptions/models/subscription/subscription_preset.dart';
import 'package:my_subscriptions/network/api_exception.dart';
import 'package:my_subscriptions/services/category_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/utils/storage.dart';
import 'package:my_subscriptions/utils/subscription_labels.dart';

const _billingCycles = ['WEEKLY', 'MONTHLY', 'QUARTERLY', 'YEARLY'];
const _currencies = ['EUR', 'USD', 'GBP'];

class SubscriptionFormScreen extends StatefulWidget {
  const SubscriptionFormScreen({super.key, this.subscriptionId});

  final String? subscriptionId;

  bool get isEdit => subscriptionId != null;

  @override
  State<SubscriptionFormScreen> createState() => _SubscriptionFormScreenState();
}

class _SubscriptionFormScreenState extends State<SubscriptionFormScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _managementUrlController = TextEditingController();

  List<CategoryItem> _categories = [];
  List<SubscriptionPreset> _presets = [];
  String? _categoryId;
  String? _selectedPresetKey;
  String _billingCycle = 'MONTHLY';
  String _currency = 'EUR';
  DateTime _renewalDate = DateTime.now().add(const Duration(days: 30));
  bool _reminderEnabled = true;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final categories = await getIt<CategoryService>().list();
      final presets = await getIt<SubscriptionService>().presets();
      final defaultCurrency = await Storage.getPreferredCurrency();

      if (widget.isEdit) {
        final item = await getIt<SubscriptionService>().getById(
          widget.subscriptionId!,
        );
        _nameController.text = item.name;
        _amountController.text = item.amount.toStringAsFixed(2);
        _renewalDate = AppDates.parseApiDate(item.nextRenewalDate);
        _notesController.text = item.notes ?? '';
        _managementUrlController.text = item.managementUrl ?? '';
        _billingCycle = item.billingCycle;
        _currency = item.currency;
        _categoryId = item.categoryId ?? categories.firstOrNull?.id;
        _selectedPresetKey = item.iconKey;
        _reminderEnabled = item.reminderEnabled;
      } else {
        _currency = defaultCurrency;
        _categoryId = await getIt<CategoryService>()
            .getDefaultForSubscription()
            .then((c) => c.id);
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _presets = presets;
          _loading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString();
          _loading = false;
        });
      }
    }
  }

  String? _categoryIdForSlug(String slug) {
    final match = _categories.where((c) => c.slug == slug);
    return match.isNotEmpty ? match.first.id : _categoryId;
  }

  void _applyPreset(SubscriptionPreset? preset) {
    if (preset == null) {
      setState(() => _selectedPresetKey = null);
      return;
    }

    setState(() {
      _selectedPresetKey = preset.key;
      _nameController.text = preset.name;
      _amountController.text = preset.defaultAmount.toStringAsFixed(2);
      _currency = preset.currency;
      _billingCycle = preset.billingCycle;
      _categoryId = _categoryIdForSlug(preset.categorySlug);
      if (preset.managementUrl != null) {
        _managementUrlController.text = preset.managementUrl!;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _managementUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _error = null);

    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    final renewal = AppDates.toApiDate(_renewalDate);
    final categoryId = _categoryId;

    if (name.isEmpty || amount == null || categoryId == null) {
      setState(() => _error = 'Compila tutti i campi obbligatori');
      return;
    }

    final notes = _notesController.text.trim();
    final managementUrl = _managementUrlController.text.trim();

    try {
      if (widget.isEdit) {
        await getIt<SubscriptionService>().update(
          widget.subscriptionId!,
          name: name,
          amount: amount,
          currency: _currency,
          billingCycle: _billingCycle,
          nextRenewalDate: renewal,
          categoryId: categoryId,
          notes: notes.isEmpty ? null : notes,
          managementUrl: managementUrl.isEmpty ? null : managementUrl,
          iconKey: _selectedPresetKey,
          reminderEnabled: _reminderEnabled,
        );
      } else {
        await getIt<SubscriptionService>().create(
          name: name,
          amount: amount,
          currency: _currency,
          billingCycle: _billingCycle,
          nextRenewalDate: renewal,
          categoryId: categoryId,
          notes: notes.isEmpty ? null : notes,
          managementUrl: managementUrl.isEmpty ? null : managementUrl,
          iconKey: _selectedPresetKey,
          reminderEnabled: _reminderEnabled,
        );
      }

      if (mounted) context.pop(true);
    } on ApiException catch (error) {
      setState(() => _error = error.message);
    } catch (error) {
      setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categoryChips = _categories
        .map(
          (c) => (
            id: c.id,
            name: c.name,
            icon: categoryIconForSlug(c.slug),
          ),
        )
        .toList();

    return AppPage(
      title: widget.isEdit ? 'Modifica abbonamento' : 'Nuovo abbonamento',
      subtitle: 'Compila i dettagli del servizio.',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                if (_presets.isNotEmpty) ...[
                  SubscriptionPresetField(
                    presets: _presets,
                    selectedKey: _selectedPresetKey,
                    onSelected: _applyPreset,
                  ),
                  const SizedBox(height: 20),
                ],
                AppField(
                  label: 'Nome abbonamento',
                  controller: _nameController,
                  prefixIcon: Icons.subscriptions_outlined,
                ),
                const SizedBox(height: 16),
                AppDropdownField<String>(
                  label: 'Ricorrenza',
                  value: _billingCycle,
                  items: _billingCycles,
                  itemLabel: billingCycleLabel,
                  prefixIcon: Icons.event_repeat_rounded,
                  onChanged: (value) {
                    if (value != null) setState(() => _billingCycle = value);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppField(
                        label: 'Importo',
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        prefixIcon: Icons.euro_rounded,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppDropdownField<String>(
                        label: 'Valuta',
                        value: _currency,
                        items: _currencies,
                        itemLabel: (v) => v,
                        onChanged: (value) {
                          if (value != null) setState(() => _currency = value);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AppDateField(
                  label: 'Prossimo pagamento',
                  value: _renewalDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                  onChanged: (date) => setState(() => _renewalDate = date),
                ),
                const SizedBox(height: 20),
                Text(
                  'Categoria',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                AppCategoryChips(
                  items: categoryChips,
                  selectedId: _categoryId,
                  onSelected: (id) => setState(() => _categoryId = id),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Promemoria rinnovo'),
                  subtitle: Text(
                    'Ricevi un avviso prima della scadenza',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                  value: _reminderEnabled,
                  activeThumbColor: scheme.onPrimary,
                  activeTrackColor: scheme.primary,
                  onChanged: (value) => setState(() => _reminderEnabled = value),
                ),
                const SizedBox(height: 8),
                AppField(
                  label: 'Note (opzionale)',
                  controller: _notesController,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                AppField(
                  label: 'URL gestione (opzionale)',
                  controller: _managementUrlController,
                  keyboardType: TextInputType.url,
                  prefixIcon: Icons.link_rounded,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!, style: TextStyle(color: scheme.error)),
                ],
                const SizedBox(height: 16),
              ],
            ),
      actions: [
        AppPageAction(
          label: 'Salva abbonamento',
          onPressed: _loading ? null : _save,
        ),
      ],
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
