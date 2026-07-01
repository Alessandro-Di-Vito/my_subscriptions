import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_subscriptions/components/dialogs/account_dialogs.dart';
import 'package:my_subscriptions/components/ui/app_card.dart';
import 'package:my_subscriptions/components/ui/app_page.dart';
import 'package:my_subscriptions/cubit/theme_cubit.dart';
import 'package:my_subscriptions/router/app_router.dart';
import 'package:my_subscriptions/services/auth_service.dart';
import 'package:my_subscriptions/services/service_locator.dart';
import 'package:my_subscriptions/services/user_service.dart';

class SettingsTabScreen extends StatelessWidget {
  const SettingsTabScreen({super.key});

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await AccountDialogs.confirmDeleteAccount(context);
    if (confirmed && context.mounted) {
      await getIt<UserService>().deleteAccount();
      getIt<ThemeCubit>().reset();
      if (context.mounted) context.go(AppRoutes.welcome);
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await AccountDialogs.confirmLogout(context);
    if (confirmed && context.mounted) {
      await getIt<AuthService>().logout();
      getIt<ThemeCubit>().reset();
      if (context.mounted) context.go(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppPage(
      title: 'Impostazioni',
      subtitle: 'Profilo, preferenze e account.',
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          AppSettingsTile(
            icon: Icons.person_outline_rounded,
            title: 'Profilo',
            subtitle: 'Nome e email',
            onTap: () => context.push(AppRoutes.settingsProfile),
          ),
          const SizedBox(height: 10),
          AppSettingsTile(
            icon: Icons.tune_rounded,
            title: 'Preferenze',
            subtitle: 'Tema, valuta e promemoria',
            onTap: () => context.push(AppRoutes.settingsPreferences),
          ),
          const SizedBox(height: 10),
          AppSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifiche',
            subtitle: 'Rinnovi e riepiloghi',
            onTap: () => context.push(AppRoutes.settingsNotifications),
          ),
          const SizedBox(height: 10),
          AppSettingsTile(
            icon: Icons.download_outlined,
            title: 'Export dati',
            subtitle: 'JSON o CSV',
            onTap: () => context.push(AppRoutes.settingsExport),
          ),
          const SizedBox(height: 28),
          Text(
            'Account',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          AppListTile(
            title: 'Logout',
            leading: Icon(Icons.logout_rounded, color: scheme.primary),
            onTap: () => _confirmLogout(context),
          ),
          const SizedBox(height: 10),
          AppListTile(
            title: 'Elimina account',
            leading: Icon(Icons.delete_outline_rounded, color: scheme.error),
            onTap: () => _confirmDeleteAccount(context),
          ),
        ],
      ),
    );
  }
}
