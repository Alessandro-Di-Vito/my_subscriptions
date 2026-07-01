import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/subscription/subscription_brand_icon.dart';
import 'package:my_subscriptions/components/subscription/subscription_preset_sheet.dart';
import 'package:my_subscriptions/models/subscription/subscription_preset.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';
import 'package:smooth_corner/smooth_corner.dart';

class SubscriptionPresetField extends StatelessWidget {
  const SubscriptionPresetField({
    required this.presets,
    required this.selectedKey,
    required this.onSelected,
    super.key,
  });

  final List<SubscriptionPreset> presets;
  final String? selectedKey;
  final ValueChanged<SubscriptionPreset?> onSelected;

  SubscriptionPreset? get _selected {
    if (selectedKey == null) return null;
    for (final preset in presets) {
      if (preset.key == selectedKey) return preset;
    }
    return null;
  }

  Future<void> _openSheet(BuildContext context) {
    return SubscriptionPresetSheet.show(
      context,
      presets: presets,
      selectedKey: selectedKey,
      onSelected: onSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _selected;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Servizio',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openSheet(context),
            borderRadius: SmoothStyle.borderRadius,
            child: SmoothContainer(
              smoothness: SmoothStyle.smoothness,
              borderRadius: SmoothStyle.borderRadius,
              color: colorScheme.surface,
              side: BorderSide(color: colorScheme.outlineVariant),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    if (selected != null)
                      SubscriptionBrandAvatar(
                        iconKey: selected.key,
                        name: selected.name,
                        brandColor: selected.color,
                        size: 44,
                      )
                    else
                      CircleAvatar(
                        backgroundColor: colorScheme.surfaceContainerHighest,
                        radius: 22,
                        child: Icon(
                          Icons.apps_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected?.name ?? 'Scegli dalla lista',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            selected == null
                                ? 'Netflix, Spotify, Disney+ e altri'
                                : 'Tocca per cambiare servizio',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
