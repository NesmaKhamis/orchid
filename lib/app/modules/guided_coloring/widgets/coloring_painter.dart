import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/coloring_picture.dart';

/// Paints the coloring picture: filled regions + dark soft green outlines.
/// Region paths are normalized (0..1) and scaled to the canvas size.
class ColoringPainter extends CustomPainter {
  const ColoringPainter({
    required this.picture,
    required this.fills,
    required this.fadeFrom,
    required this.fadeProgress,
  });

  final ColoringPicture picture;
  final Map<String, Color> fills;
  final Map<String, Color?> fadeFrom;
  final double fadeProgress;

  @override
  void paint(Canvas canvas, Size size) {
    final double scale = size.width;
    final Paint fillPaint = Paint()..style = PaintingStyle.fill;
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = AppColors.paletteGreen;

    for (final region in picture.regions) {
      final Path path = region.path.transform(
        Matrix4.diagonal3Values(scale, scale, 1).storage,
      );

      Color color = fills[region.id] ?? Colors.white;
      final Color? from = fadeFrom[region.id];
      if (from != null) {
        color = Color.lerp(from, color, fadeProgress) ?? color;
      }
      fillPaint.color = color;

      canvas.drawPath(path, fillPaint);
      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant ColoringPainter oldDelegate) {
    return oldDelegate.fadeProgress != fadeProgress ||
        oldDelegate.fills.length != fills.length ||
        oldDelegate.picture.id != picture.id;
  }
}
