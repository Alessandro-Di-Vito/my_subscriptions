import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/sketch/sketch_screen.dart';
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
  final _nameController = TextEditingController(text: 'Netflix');
  final _amountController = TextEditingController(text: '9.99');
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    setState(() => _error = null);

    try {
      final currency = await Storage.getPreferredCurrency();
      final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
      if (amount == null) {
        throw Exception('Importo non valido');
      }

      final category = await getIt<CategoryService>().getDefaultForSubscription();

      await getIt<SubscriptionService>().create(
        name: _nameController.text.trim(),
        amount: amount,
        currency: currency,
        billingCycle: 'MONTHLY',
        nextRenewalDate: DateTime.now()
            .add(const Duration(days: 30))
            .toIso8601String()
            .split('T')
            .first,
        categoryId: category.id,
      );

      if (mounted) {
        context.go(AppRoutes.home);
      }
    } on ApiException catch (error) {
      setState(() => _error = error.message);
    } catch (error) {
      setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SketchScreen(
      title: 'Primo abbonamento',
      subtitle: 'Aggiungi il tuo primo abbonamento per iniziare.',
      body: ListView(
        children: [
          SketchField(label: 'Nome', controller: _nameController),
          const SizedBox(height: 16),
          SketchField(
            label: 'Importo mensile',
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        SketchAction(
          label: 'Salva e vai alla Home',
          onPressed: _create,
        ),
        SketchAction(
          label: 'Salta per ora',
          isPrimary: false,
          onPressed: () => context.go(AppRoutes.home),
        ),
      ],
    );
  }
}
