import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_fields.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/cubit/theme_cubit.dart';
import 'package:my_subscriptions/models/user/user_profile.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';

const _currencies = ['EUR', 'USD', 'GBP'];

class SettingsPreferencesScreen extends StatefulWidget {
  const SettingsPreferencesScreen({super.key});

  @override
  State<SettingsPreferencesScreen> createState() =>
      _SettingsPreferencesScreenState();
}

class _SettingsPreferencesScreenState extends State<SettingsPreferencesScreen> {
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

  Future<void> _setTheme(ThemeMode mode) async {
    await getIt<ThemeCubit>().setTheme(ThemeCubit.apiFromThemeMode(mode));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _preferences;
    final themeMode = getIt<ThemeCubit>().mode;
    final scheme = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Preferenze',
      subtitle: 'Personalizza l\'esperienza dell\'app.',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : prefs == null
          ? const Center(child: Text('Impossibile caricare le preferenze'))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Text(
                  'Tema',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                SegmentedButton<ThemeMode>(
                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Chiaro'),
                      icon: Icon(Icons.light_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Scuro'),
                      icon: Icon(Icons.dark_mode_outlined),
                    ),
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Sistema'),
                      icon: Icon(Icons.brightness_auto_outlined),
                    ),
                  ],
                  selected: {themeMode},
                  onSelectionChanged: (s) => _setTheme(s.first),
                ),
                const SizedBox(height: 24),
                AppDropdownField<String>(
                  label: 'Valuta predefinita',
                  value: prefs.defaultCurrency,
                  items: _currencies,
                  itemLabel: (v) => v,
                  prefixIcon: Icons.payments_outlined,
                  onChanged: (value) {
                    if (value != null) {
                      _updatePreferences(prefs.copyWith(defaultCurrency: value));
                    }
                  },
                ),
                const SizedBox(height: 24),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Promemoria predefinito',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${prefs.reminderDaysDefault} giorni prima del rinnovo',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      Slider(
                        value: prefs.reminderDaysDefault.toDouble(),
                        min: 1,
                        max: 30,
                        divisions: 29,
                        activeColor: scheme.primary,
                        label: '${prefs.reminderDaysDefault}',
                        onChanged: (value) {
                          setState(() {
                            _preferences = prefs.copyWith(
                              reminderDaysDefault: value.round(),
                            );
                          });
                        },
                        onChangeEnd: (value) {
                          _updatePreferences(
                            prefs.copyWith(reminderDaysDefault: value.round()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
