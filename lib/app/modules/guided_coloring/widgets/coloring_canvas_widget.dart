import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../data/models/coloring_picture.dart';
import '../controllers/guided_coloring_controller.dart';
import 'coloring_painter.dart';

/// Square canvas showing the outline picture; tap fills a region.
class ColoringCanvasWidget extends StatefulWidget {
  const ColoringCanvasWidget({super.key});

  @override
  State<ColoringCanvasWidget> createState() => _ColoringCanvasWidgetState();
}

class _ColoringCanvasWidgetState extends State<ColoringCanvasWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Worker _fillWorker;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fillWorker = ever(_controller.fillStamp, (_) {
      if (_controller.fadeFrom.isNotEmpty) {
        _fadeController.forward(from: 0);
      }
    });
  }

  GuidedColoringController get _controller =>
      Get.find<GuidedColoringController>();

  @override
  void dispose() {
    _fillWorker.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          border: Border.all(color: AppColors.border),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusCard),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Size canvasSize = Size(
                constraints.maxWidth,
                constraints.maxWidth,
              );
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: (TapUpDetails details) => _controller.onCanvasTap(
                  details.localPosition,
                  canvasSize,
                ),
                child: AnimatedBuilder(
                  animation: _fadeController,
                  builder: (BuildContext context, Widget? child) {
                    // Obx so the canvas repaints immediately on picture
                    // switch, fills, undo/redo — not only during fades.
                    return Obx(() {
                      final ColoringPicture? picture =
                          _controller.currentPicture.value;
                      if (picture == null) {
                        return const SizedBox.expand();
                      }
                      return CustomPaint(
                        size: canvasSize,
                        painter: ColoringPainter(
                          picture: picture,
                          fills: Map.of(_controller.fills),
                          fadeFrom: Map.of(_controller.fadeFrom),
                          fadeProgress: _fadeController.value,
                        ),
                      );
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

