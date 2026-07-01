import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/feedback/app_snackbar.dart';

abstract final class ExportFeedback {
  static void jsonCopied(BuildContext context, {required int subscriptionCount}) {
    AppSnackbar.success(
      context,
      'JSON copiato negli appunti ($subscriptionCount abbonamenti)',
    );
  }

  static void csvCopied(BuildContext context, {required int subscriptionCount}) {
    AppSnackbar.success(
      context,
      'CSV copiato negli appunti ($subscriptionCount abbonamenti)',
    );
  }
}
