import 'package:intl/intl.dart';

String formatMoney(double amount, {String currency = 'EUR'}) {
  final symbol = switch (currency) {
    'EUR' => '€',
    'USD' => '\$',
    'GBP' => '£',
    _ => currency,
  };
  final formatted = NumberFormat('#,##0.00', 'it_IT').format(amount);
  return '$symbol $formatted';
}

String formatMoneyCompact(double amount, {String currency = 'EUR'}) {
  final symbol = switch (currency) {
    'EUR' => '€',
    'USD' => '\$',
    'GBP' => '£',
    _ => currency,
  };
  return '$symbol${amount.toStringAsFixed(2)}';
}
