import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/app_buttons.dart';

/// Layout principale dell'app: header, body scrollabile, azioni in fondo.
class AppPage extends StatelessWidget {
  const AppPage({
    required this.title,
    super.key,
    this.subtitle,
    this.body,
    this.actions = const [],
    this.showAppBar = true,
    this.appBarActions,
    this.floatingActionButton,
    this.onRefresh,
  });

  final String title;
  final String? subtitle;
  final Widget? body;
  final List<AppPageAction> actions;
  final bool showAppBar;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final canPop = Navigator.of(context).canPop();

    Widget? content = body;
    if (content != null && onRefresh != null) {
      content = RefreshIndicator(
        onRefresh: onRefresh!,
        color: scheme.primary,
        child: content,
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: floatingActionButton,
      appBar: showAppBar
          ? AppBar(
              title: Text(title),
              automaticallyImplyLeading: canPop,
              actions: appBarActions,
            )
          : null,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!showAppBar) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
            if (subtitle != null) ...[
              Padding(
                padding: EdgeInsets.fromLTRB(20, showAppBar ? 0 : 4, 20, 0),
                child: Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else if (!showAppBar) ...[
              const SizedBox(height: 8),
            ],
            if (content != null) Expanded(child: content),
            if (content == null) const Spacer(),
            if (actions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Column(
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(height: 10),
                      actions[i].isPrimary
                          ? AppPrimaryButton(
                              label: actions[i].label,
                              onPressed: actions[i].onPressed,
                            )
                          : AppSecondaryButton(
                              label: actions[i].label,
                              onPressed: actions[i].onPressed,
                            ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppPageAction {
  const AppPageAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;
}
