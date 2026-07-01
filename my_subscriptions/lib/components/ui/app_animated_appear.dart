import 'package:flutter/material.dart';

/// Fade + slide in con ritardo opzionale per liste e sezioni.
class AppAnimatedAppear extends StatefulWidget {
  const AppAnimatedAppear({
    required this.child,
    super.key,
    this.index = 0,
    this.duration = const Duration(milliseconds: 420),
    this.offsetY = 18,
  });

  final Widget child;
  final int index;
  final Duration duration;
  final double offsetY;

  @override
  State<AppAnimatedAppear> createState() => _AppAnimatedAppearState();
}

class _AppAnimatedAppearState extends State<AppAnimatedAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _opacity = curve;
    _offset = Tween<Offset>(
      begin: Offset(0, widget.offsetY / 100),
      end: Offset.zero,
    ).animate(curve);

    Future<void>.delayed(
      Duration(milliseconds: 60 * widget.index),
      () {
        if (mounted) _controller.forward();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _offset,
        child: widget.child,
      ),
    );
  }
}
