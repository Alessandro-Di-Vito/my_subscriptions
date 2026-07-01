import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/dialogs/app_confirm_dialog.dart';

abstract final class SubscriptionDialogs {
  static Future<bool> confirmCancel(BuildContext context) {
    return AppConfirmDialog.show(
      context,
      title: 'Annulla abbonamento',
      message: 'Vuoi segnare questo abbonamento come cancellato? '
          'Potrai ancora vederlo nello storico.',
      confirmLabel: 'Segna cancellato',
      cancelLabel: 'Indietro',
      icon: Icons.cancel_outlined,
    );
  }

  static Future<bool> confirmDelete(
    BuildContext context, {
    required String subscriptionName,
  }) {
    return AppConfirmDialog.show(
      context,
      title: 'Elimina abbonamento',
      message: 'Eliminare definitivamente "$subscriptionName"? '
          'Questa azione non può essere annullata.',
      confirmLabel: 'Elimina',
      cancelLabel: 'Annulla',
      isDestructive: true,
      icon: Icons.delete_outline,
    );
  }
}
