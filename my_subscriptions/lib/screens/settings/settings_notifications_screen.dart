import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/models/user/user_profile.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';

class SettingsNotificationsScreen extends StatefulWidget {
  const SettingsNotificationsScreen({super.key});

  @override
  State<SettingsNotificationsScreen> createState() =>
      _SettingsNotificationsScreenState();
}

class _SettingsNotificationsScreenState
    extends State<SettingsNotificationsScreen> {
  UserPreferences? _preferences;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final prefs = await getIt<UserService>().getPreferences();
      if (mounted) {
        setState(() {
          _preferences = prefs;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _updatePreferences(UserPreferences updated) async {
    final saved = await getIt<UserService>().updatePreferences(updated);
    if (mounted) setState(() => _preferences = saved);
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _preferences;
    final scheme = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Notifiche',
      subtitle: 'Scegli quali avvisi ricevere.',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : prefs == null
          ? const Center(child: Text('Impossibile caricare le preferenze'))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                AppCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Promemoria rinnovi'),
                    subtitle: Text(
                      'Avviso prima della scadenza',
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                    value: prefs.notificationsRenewal,
                    activeThumbColor: scheme.onPrimary,
                    activeTrackColor: scheme.primary,
                    onChanged: (value) => _updatePreferences(
                      prefs.copyWith(notificationsRenewal: value),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AppCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Promemoria trial'),
                    subtitle: Text(
                      'Fine periodo di prova',
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                    value: prefs.notificationsTrial,
                    activeThumbColor: scheme.onPrimary,
                    activeTrackColor: scheme.primary,
                    onChanged: (value) => _updatePreferences(
                      prefs.copyWith(notificationsTrial: value),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AppCard(
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Riepilogo periodico'),
                    subtitle: Text(
                      'Riepilogo spese ricorrenti',
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    ),
                    value: prefs.notificationsSummary,
                    activeThumbColor: scheme.onPrimary,
                    activeTrackColor: scheme.primary,
                    onChanged: (value) => _updatePreferences(
                      prefs.copyWith(notificationsSummary: value),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
