import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/feedback/app_snackbar.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_fields.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/models/user/user_profile.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  final _nameController = TextEditingController();
  UserProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final profile = await getIt<UserService>().getProfile();
      _nameController.text = profile.displayName ?? '';
      if (mounted) {
        setState(() {
          _profile = profile;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    await getIt<UserService>().updateProfile(
      displayName: _nameController.text.trim(),
    );
    if (mounted) {
      AppSnackbar.success(context, 'Profilo aggiornato');
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Profilo',
      subtitle: 'I tuoi dati account.',
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                AppListTile(
                  title: 'Email',
                  subtitle: _profile?.email ?? '—',
                  leading: const Icon(Icons.mail_outline_rounded),
                ),
                const SizedBox(height: 16),
                AppField(
                  label: 'Nome visualizzato',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                ),
              ],
            ),
      actions: [
        AppPageAction(label: 'Salva', onPressed: _loading ? null : _save),
      ],
    );
  }
}
