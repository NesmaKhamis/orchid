import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class FloatingBackground extends StatefulWidget {
  const FloatingBackground({super.key});

  static const Duration loopDuration = Duration(seconds: 32);

  @override
  State<FloatingBackground> createState() => _FloatingBackgroundState();
}

class _FloatingBackgroundState extends State<FloatingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool? _animationsDisabled;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: FloatingBackground.loopDuration,
      value: 0.18,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;
    if (_animationsDisabled == disableAnimations) return;
    _animationsDisabled = disableAnimations;
    if (disableAnimations) {
      _controller.stop();
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return CustomPaint(
              painter: _FloatingShapesPainter(progress: _controller.value),
              child: child,
            );
          },
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _FloatingShape {
  const _FloatingShape({
    required this.x,
    required this.y,
    required this.radius,
    required this.phase,
    required this.opacity,
    required this.color,
    this.isPetal = false,
  });

  final double x;
  final double y;
  final double radius;
  final double phase;
  final double opacity;
  final Color color;
  final bool isPetal;
}

class _FloatingShapesPainter extends CustomPainter {
  const _FloatingShapesPainter({required this.progress});

  final double progress;

  static const List<_FloatingShape> _shapes = <_FloatingShape>[
    _FloatingShape(
      x: 0.12,
      y: 0.16,
      radius: 15,
      phase: 0.02,
      opacity: 0.12,
      color: AppColors.softPink,
    ),
    _FloatingShape(
      x: 0.82,
      y: 0.13,
      radius: 11,
      phase: 0.18,
      opacity: 0.1,
      color: AppColors.primary,
      isPetal: true,
    ),
    _FloatingShape(
      x: 0.9,
      y: 0.38,
      radius: 18,
      phase: 0.38,
      opacity: 0.08,
      color: AppColors.softMint,
    ),
    _FloatingShape(
      x: 0.08,
      y: 0.48,
      radius: 12,
      phase: 0.52,
      opacity: 0.14,
      color: AppColors.softYellow,
      isPetal: true,
    ),
    _FloatingShape(
      x: 0.86,
      y: 0.66,
      radius: 14,
      phase: 0.66,
      opacity: 0.1,
      color: AppColors.softBlue,
    ),
    _FloatingShape(
      x: 0.17,
      y: 0.78,
      radius: 19,
      phase: 0.78,
      opacity: 0.09,
      color: AppColors.lavender,
      isPetal: true,
    ),
    _FloatingShape(
      x: 0.7,
      y: 0.9,
      radius: 10,
      phase: 0.9,
      opacity: 0.16,
      color: AppColors.softPink,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final _FloatingShape shape in _shapes) {
      final double angle = (progress + shape.phase) * math.pi * 2;
      final Offset center = Offset(
        size.width * shape.x + math.sin(angle) * 12,
        size.height * shape.y + math.cos(angle) * 16,
      );
      final Paint paint = Paint()
        ..color = shape.color.withValues(alpha: shape.opacity);
      if (shape.isPetal) {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(math.sin(angle) * 0.25);
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: shape.radius,
            height: shape.radius * 1.8,
          ),
          paint,
        );
        canvas.restore();
      } else {
        canvas.drawCircle(center, shape.radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_FloatingShapesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
