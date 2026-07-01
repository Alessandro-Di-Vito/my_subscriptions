import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/dialogs/app_confirm_dialog.dart';

abstract final class AccountDialogs {
  static Future<bool> confirmLogout(BuildContext context) {
    return AppConfirmDialog.show(
      context,
      title: 'Logout',
      message: 'Vuoi uscire dal tuo account?',
      confirmLabel: 'Esci',
      cancelLabel: 'Annulla',
      icon: Icons.logout,
    );
  }

  static Future<bool> confirmDeleteAccount(BuildContext context) {
    return AppConfirmDialog.show(
      context,
      title: 'Elimina account',
      message: 'Questa azione è irreversibile. '
          'Tutti i tuoi abbonamenti e i dati verranno eliminati.',
      confirmLabel: 'Elimina account',
      cancelLabel: 'Annulla',
      isDestructive: true,
      icon: Icons.warning_amber_rounded,
    );
  }
}
