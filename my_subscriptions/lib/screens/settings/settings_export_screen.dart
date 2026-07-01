import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_subscriptions/components/feedback/export_feedback.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';

class SettingsExportScreen extends StatelessWidget {
  const SettingsExportScreen({super.key});

  Future<void> _exportJson(BuildContext context) async {
    final data = await getIt<UserService>().exportData();
    final json = data.toString();
    await Clipboard.setData(ClipboardData(text: json));
    if (context.mounted) {
      ExportFeedback.jsonCopied(
        context,
        subscriptionCount: data['subscriptions']?.length ?? 0,
      );
    }
  }

  Future<void> _exportCsv(BuildContext context) async {
    final data = await getIt<UserService>().exportData();
    final subscriptions = data['subscriptions'] as List<dynamic>? ?? [];
    final buffer = StringBuffer(
      'name,amount,currency,billingCycle,status,nextRenewalDate,category\n',
    );

    for (final raw in subscriptions) {
      final item = raw as Map<String, dynamic>;
      final category = item['category'] as Map<String, dynamic>?;
      final row = [
        _csvEscape(item['name'] as String? ?? ''),
        '${item['amount']}',
        item['currency'] as String? ?? '',
        item['billingCycle'] as String? ?? '',
        item['status'] as String? ?? '',
        _formatDate(item['nextRenewalDate']),
        _csvEscape(category?['name'] as String? ?? ''),
      ];
      buffer.writeln(row.join(','));
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (context.mounted) {
      ExportFeedback.csvCopied(
        context,
        subscriptionCount: subscriptions.length,
      );
    }
  }

  String _formatDate(dynamic value) {
    if (value == null) return '';
    return value.toString().split('T').first;
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Export dati',
      subtitle: 'Copia i tuoi dati negli appunti.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          AppSettingsTile(
            icon: Icons.code_rounded,
            title: 'Esporta JSON',
            subtitle: 'Profilo, abbonamenti e storico',
            onTap: () => _exportJson(context),
          ),
          const SizedBox(height: 10),
          AppSettingsTile(
            icon: Icons.table_chart_outlined,
            title: 'Esporta CSV',
            subtitle: 'Compatibile con Excel',
            onTap: () => _exportCsv(context),
          ),
        ],
      ),
    );
  }
}
