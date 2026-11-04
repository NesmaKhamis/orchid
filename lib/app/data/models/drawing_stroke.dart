import 'dart:ui' show Color, Offset;

import 'drawing_tool.dart';

/// A single immutable drawing stroke on the canvas.
class DrawingStroke {
  const DrawingStroke({
    required this.points,
    required this.color,
    required this.width,
    required this.tool,
  });

  final List<Offset> points;
  final Color color;
  final double width;
  final DrawingTool tool;
}
