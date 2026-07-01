import 'package:flutter/material.dart';
import 'package:my_subscriptions/components/ui/app_buttons.dart';

enum AppEmptyIllustration {
  subscriptions,
  calendar,
  analytics,
  search,
}

class AppEmptyState extends StatefulWidget {
  const AppEmptyState({
    required this.title,
    super.key,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.illustration = AppEmptyIllustration.subscriptions,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AppEmptyIllustration illustration;

  @override
  State<AppEmptyState> createState() => _AppEmptyStateState();
}

class _AppEmptyStateState extends State<AppEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -6 * _floatController.value),
                child: child,
              );
            },
            child: _EmptyIllustration(type: widget.illustration),
          ),
          const SizedBox(height: 20),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          if (widget.actionLabel != null && widget.onAction != null) ...[
            const SizedBox(height: 20),
            AppPrimaryButton(
              label: widget.actionLabel!,
              onPressed: widget.onAction,
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration({required this.type});

  final AppEmptyIllustration type;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 140,
      height: 120,
      child: CustomPaint(
        painter: _EmptyIllustrationPainter(
          primary: scheme.primary,
          surface: scheme.surface,
          outline: scheme.outline,
          type: type,
        ),
      ),
    );
  }
}

class _EmptyIllustrationPainter extends CustomPainter {
  _EmptyIllustrationPainter({
    required this.primary,
    required this.surface,
    required this.outline,
    required this.type,
  });

  final Color primary;
  final Color surface;
  final Color outline;
  final AppEmptyIllustration type;

  @override
  void paint(Canvas canvas, Size size) {
    final cardPaint = Paint()
      ..color = surface
      ..style = PaintingStyle.fill;
    final border = Paint()
      ..color = outline.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    void drawCard(Rect rect, {double radius = 12}) {
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
      canvas.drawRRect(rrect, cardPaint);
      canvas.drawRRect(rrect, border);
    }

    switch (type) {
      case AppEmptyIllustration.subscriptions:
        drawCard(Rect.fromLTWH(18, 28, 88, 56));
        drawCard(Rect.fromLTWH(34, 14, 88, 56));
        canvas.drawCircle(const Offset(52, 36), 10, Paint()..color = primary);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(68, 32, 40, 8),
            const Radius.circular(4),
          ),
          Paint()..color = primary.withValues(alpha: 0.35),
        );
      case AppEmptyIllustration.calendar:
        drawCard(Rect.fromLTWH(24, 20, 92, 78), radius: 14);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(36, 34, 68, 10),
            const Radius.circular(5),
          ),
          Paint()..color = primary.withValues(alpha: 0.25),
        );
        for (var i = 0; i < 3; i++) {
          canvas.drawCircle(
            Offset(48 + i * 22, 62),
            i == 1 ? 7 : 4,
            Paint()
              ..color = i == 1 ? primary : primary.withValues(alpha: 0.4),
          );
        }
      case AppEmptyIllustration.analytics:
        drawCard(Rect.fromLTWH(20, 24, 100, 72));
        canvas.drawArc(
          Rect.fromCircle(center: const Offset(70, 60), radius: 28),
          -1.2,
          2.4,
          false,
          Paint()
            ..color = primary
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10
            ..strokeCap = StrokeCap.round,
        );
      case AppEmptyIllustration.search:
        drawCard(Rect.fromLTWH(16, 40, 108, 44), radius: 22);
        canvas.drawCircle(const Offset(46, 62), 10, border);
        canvas.drawLine(
          const Offset(54, 70),
          const Offset(66, 82),
          Paint()
            ..color = outline.withValues(alpha: 0.6)
            ..strokeWidth = 2.5,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _EmptyIllustrationPainter oldDelegate) => false;
}
