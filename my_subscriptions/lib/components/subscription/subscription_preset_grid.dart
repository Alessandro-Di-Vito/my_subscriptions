import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/subscription/subscription_brand_icon.dart';
import 'package:my_subscriptions/components/ui/app_empty_state.dart';
import 'package:my_subscriptions/l10n/app_localizations.dart';
import 'package:my_subscriptions/components/subscription/subscription_preset_tile.dart';
import 'package:my_subscriptions/models/subscription/subscription_preset.dart';

class SubscriptionPresetGrid extends StatelessWidget {
  const SubscriptionPresetGrid({
    required this.presets,
    required this.selectedKey,
    required this.onSelected,
    required this.searchQuery,
    super.key,
  });

  final List<SubscriptionPreset> presets;
  final String? selectedKey;
  final ValueChanged<SubscriptionPreset?> onSelected;
  final String searchQuery;

  List<SubscriptionPreset> get _filtered {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return presets;
    return presets
        .where((preset) => preset.name.toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final filtered = _filtered;

    if (filtered.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return AppEmptyState(
        illustration: AppEmptyIllustration.search,
        title: l10n.emptyNoSearchResults,
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.82,
      ),
      itemCount: filtered.length + 1,
      itemBuilder: (context, index) {
        if (index == filtered.length) {
          return SubscriptionPresetTile(
            label: 'Altro',
            selected: selectedKey == null,
            onTap: () => onSelected(null),
            child: CircleAvatar(
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.edit_outlined,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        final preset = filtered[index];
        return SubscriptionPresetTile(
          label: preset.name,
          selected: selectedKey == preset.key,
          onTap: () => onSelected(preset),
          child: SubscriptionBrandAvatar(
            iconKey: preset.key,
            name: preset.name,
            brandColor: preset.color,
            size: 44,
          ),
        );
      },
    );
  }
}
