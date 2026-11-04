import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../data/models/drawing_stroke.dart';
import '../../../data/models/drawing_tool.dart';

/// Paints all committed strokes (plus spray dots) inside the canvas bounds.
class DrawingPainter extends CustomPainter {
  const DrawingPainter({required this.strokes});

  final List<DrawingStroke> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    for (final DrawingStroke stroke in strokes) {
      switch (stroke.tool) {
        case DrawingTool.pen:
        case DrawingTool.brush:
          _paintLine(canvas, stroke);
          break;
        case DrawingTool.spray:
          _paintSpray(canvas, stroke);
          break;
      }
    }
  }

  void _paintLine(Canvas canvas, DrawingStroke stroke) {
    if (stroke.points.isEmpty) {
      return;
    }
    final Paint paint = Paint()
      ..color = stroke.tool == DrawingTool.brush
          ? stroke.color.withValues(alpha: 0.9)
          : stroke.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke.width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..filterQuality = FilterQuality.medium
      ..maskFilter = stroke.tool == DrawingTool.brush
          ? const MaskFilter.blur(BlurStyle.normal, 1)
          : null;

    final Path path = Path()..moveTo(stroke.points.first.dx, stroke.points.first.dy);
    for (int i = 1; i < stroke.points.length; i++) {
      path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
    }
    canvas.drawPath(path, paint);
  }

  /// Spray: draws scattered dots deterministically around each anchor point.
  void _paintSpray(Canvas canvas, DrawingStroke stroke) {
    final Paint paint = Paint()
      ..color = stroke.color.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final math.Random random = math.Random(stroke.points.first.hashCode);
    final double spread = stroke.width * 1.4;

    for (final Offset anchor in stroke.points) {
      const int dotsPerAnchor = 10;
      for (int i = 0; i < dotsPerAnchor; i++) {
        final double angle = random.nextDouble() * math.pi * 2;
        final double radius = random.nextDouble() * spread;
        canvas.drawCircle(
          anchor + Offset(math.cos(angle) * radius, math.sin(angle) * radius),
          1.0 + random.nextDouble() * 1.5,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}
