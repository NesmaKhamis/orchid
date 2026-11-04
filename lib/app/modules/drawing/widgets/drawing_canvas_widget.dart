import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../controllers/drawing_controller.dart';
import 'drawing_painter.dart';

/// The white drawing canvas: sun decoration + gesture-driven painting.
class DrawingCanvasWidget extends StatelessWidget {
  const DrawingCanvasWidget({super.key});

  static const double _height = 340;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(color: AppColors.border),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            child: GetBuilder<DrawingController>(
              id: DrawingController.canvasId,
              builder: (DrawingController controller) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (DragStartDetails details) =>
                      controller.onPanStart(details.localPosition),
                  onPanUpdate: (DragUpdateDetails details) =>
                      controller.onPanUpdate(details.localPosition),
                  onPanEnd: (_) => controller.onPanEnd(),
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: DrawingPainter(
                      strokes: List.of(controller.strokes),
                    ),
                  ),
                );
              },
            ),
          ),
          // Decorative sun, not part of the drawing.
          const PositionedDirectional(
            top: AppDimens.space8,
            end: AppDimens.space8,
            child: IgnorePointer(
              child: Icon(
                Icons.wb_sunny_rounded,
                size: 56,
                color: AppColors.softYellow,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
