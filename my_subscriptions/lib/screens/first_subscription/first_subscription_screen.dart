import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/sketch/sketch_date_picker.dart';
import 'package:my_subscriptions/components/subscription/subscription_preset_field.dart';
import 'package:my_subscriptions/components/ui/app_fields.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/models/category/category_item.dart';
import 'package:my_subscriptions/models/subscription/subscription_preset.dart';
import 'package:my_subscriptions/network/api_exception.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/category_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/subscription_service.dart';
import 'package:my_subscriptions/utils/storage.dart';

class FirstSubscriptionScreen extends StatefulWidget {
  const FirstSubscriptionScreen({super.key});

  @override
  State<FirstSubscriptionScreen> createState() => _FirstSubscriptionScreenState();
}

class _FirstSubscriptionScreenState extends State<FirstSubscriptionScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  List<CategoryItem> _categories = [];
  List<SubscriptionPreset> _presets = [];
  String? _categoryId;
  String? _selectedPresetKey;
  String _currency = 'EUR';
  DateTime _renewalDate = DateTime.now().add(const Duration(days: 30));
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
      final currency = await Storage.getPreferredCurrency();
      final defaultCategory =
          await getIt<CategoryService>().getDefaultForSubscription();

      if (mounted) {
        setState(() {
          _categories = categories;
          _presets = presets;
          _currency = currency;
          _categoryId = defaultCategory.id;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _categoryIdForSlug(String slug) {
    final match = _categories.where((c) => c.slug == slug);
    return match.isNotEmpty ? match.first.id : _categoryId;
  }

  void _applyPreset(SubscriptionPreset? preset) {
    if (preset == null) {
      setState(() {
        _selectedPresetKey = null;
        _nameController.clear();
        _amountController.clear();
      });
      return;
    }

    setState(() {
      _selectedPresetKey = preset.key;
      _nameController.text = preset.name;
      _amountController.text = preset.defaultAmount.toStringAsFixed(2);
      _currency = preset.currency;
      _categoryId = _categoryIdForSlug(preset.categorySlug);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() => _error = null);

    try {
      final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
      if (amount == null) throw Exception('Importo non valido');

      final categoryId = _categoryId;
      if (categoryId == null) throw Exception('Categoria non disponibile');

      await getIt<SubscriptionService>().create(
        name: _nameController.text.trim(),
        amount: amount,
        currency: _currency,
        billingCycle: 'MONTHLY',
        nextRenewalDate: AppDates.toApiDate(_renewalDate),
        categoryId: categoryId,
        iconKey: _selectedPresetKey,
      );

      if (mounted) context.go(AppRoutes.home);
    } on ApiException catch (error) {
      setState(() => _error = error.message);
    } catch (error) {
      setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Primo abbonamento',
      subtitle: 'Aggiungi il tuo primo servizio per iniziare.',
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
                  label: 'Nome',
                  controller: _nameController,
                  prefixIcon: Icons.subscriptions_outlined,
                ),
                const SizedBox(height: 16),
                AppField(
                  label: 'Importo mensile',
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  prefixIcon: Icons.euro_rounded,
                ),
                const SizedBox(height: 16),
                AppDateField(
                  label: 'Prossimo rinnovo',
                  value: _renewalDate,
                  onChanged: (date) => setState(() => _renewalDate = date),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 16),
                  Text(_error!, style: TextStyle(color: scheme.error)),
                ],
              ],
            ),
      actions: [
        AppPageAction(
          label: 'Salva e vai alla Home',
          onPressed: _loading ? null : _create,
        ),
        AppPageAction(
          label: 'Salta per ora',
          isPrimary: false,
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}
