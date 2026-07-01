import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/subscription/subscription_preset_grid.dart';
import 'package:my_subscriptions/components/ui/smooth_surface.dart';
import 'package:my_subscriptions/models/subscription/subscription_preset.dart';
import 'package:my_subscriptions/utils/smooth_style.dart';

abstract final class SubscriptionPresetSheet {
  static Future<void> show(
    BuildContext context, {
    required List<SubscriptionPreset> presets,
    required String? selectedKey,
    required ValueChanged<SubscriptionPreset?> onSelected,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: smoothSheetShape(),
      builder: (context) {
        return _SubscriptionPresetSheetBody(
          presets: presets,
          selectedKey: selectedKey,
          onSelected: (preset) {
            onSelected(preset);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _SubscriptionPresetSheetBody extends StatefulWidget {
  const _SubscriptionPresetSheetBody({
    required this.presets,
    required this.selectedKey,
    required this.onSelected,
  });

  final List<SubscriptionPreset> presets;
  final String? selectedKey;
  final ValueChanged<SubscriptionPreset?> onSelected;

  @override
  State<_SubscriptionPresetSheetBody> createState() =>
      _SubscriptionPresetSheetBodyState();
}

class _SubscriptionPresetSheetBodyState extends State<_SubscriptionPresetSheetBody> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ListView(
            controller: scrollController,
            children: [
              Text(
                'Scegli un servizio',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Oltre ${widget.presets.length} abbonamenti popolari',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              SmoothSurface(
                width: double.infinity,
                borderRadius: SmoothStyle.borderRadius,
                color: scheme.surfaceContainerHighest,
                side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Cerca Netflix, Spotify…',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),
              const SizedBox(height: 16),
              SubscriptionPresetGrid(
                presets: widget.presets,
                selectedKey: widget.selectedKey,
                searchQuery: _searchQuery,
                onSelected: widget.onSelected,
              ),
            ],
          ),
        );
      },
    );
  }
}
