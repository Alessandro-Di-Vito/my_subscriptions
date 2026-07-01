import 'dart:math' as math;

import 'package:flutter/material.dart';

class DonutSegment {
  const DonutSegment({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

class AppDonutChart extends StatelessWidget {
  const AppDonutChart({
    required this.segments,
    super.key,
    this.centerTitle,
    this.centerSubtitle,
    this.size = 200,
    this.strokeWidth = 22,
  });

  final List<DonutSegment> segments;
  final String? centerTitle;
  final String? centerSubtitle;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<double>(0, (sum, s) => sum + s.value);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(
              segments: segments,
              total: total,
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerTitle != null)
            Padding(
              padding: EdgeInsets.all(strokeWidth + 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    centerTitle!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (centerSubtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      centerSubtitle!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.segments,
    required this.total,
    required this.strokeWidth,
  });

  final List<DonutSegment> segments;
  final double total;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    if (total <= 0) return;

    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.shortestSide / 2 - strokeWidth / 2;
    var startAngle = -math.pi / 2;

    for (final segment in segments) {
      if (segment.value <= 0) continue;
      final sweep = (segment.value / total) * 2 * math.pi;
      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep,
        false,
        paint,
      );
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.segments != segments || oldDelegate.total != total;
  }
}

class DonutLegend extends StatelessWidget {
  const DonutLegend({required this.segments, super.key});

  final List<DonutSegment> segments;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: segments.map((segment) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: segment.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  segment.label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                segment.value.toStringAsFixed(2),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
