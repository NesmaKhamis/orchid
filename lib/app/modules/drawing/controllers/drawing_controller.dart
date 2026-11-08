import 'dart:ui' show Offset;

import 'package:flutter/material.dart' show Color;
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/drawing_stroke.dart';
import '../../../data/models/drawing_tool.dart';

/// Controller for the free-drawing canvas (مرسمي الصغير).
class DrawingController extends GetxController {
  static const double brushMinSize = 2;
  static const double brushMaxSize = 30;

  static const String canvasId = 'canvas';

  final strokes = <DrawingStroke>[].obs;
  final redoStack = <DrawingStroke>[].obs;
  final selectedTool = DrawingTool.brush.obs;
  final selectedColor = AppColors.primary.obs;
  final brushWidth = 12.0.obs;
  final isMuted = false.obs;

  void selectColor(Color color) {
    selectedColor.value = color;
  }

  void selectTool(DrawingTool tool) {
    selectedTool.value = tool;
  }

  void setBrushWidth(double width) {
    brushWidth.value = width;
  }

  void toggleSound() {
    isMuted.value = !isMuted.value;
  }

  bool get canUndo => strokes.isNotEmpty;

  bool get canRedo => redoStack.isNotEmpty;

  /// Starts a new stroke at the touch point.
  void onPanStart(Offset point) {
    redoStack.clear();
    strokes.add(
      DrawingStroke(
        points: <Offset>[point],
        color: selectedColor.value,
        width: _effectiveWidth(),
        tool: selectedTool.value,
      ),
    );
    update([canvasId]);
  }

  /// Extends the current stroke; spray sprinkles sparse anchors while the
  /// finger moves, pen/brush follow the touch continuously.
  void onPanUpdate(Offset point) {
    if (strokes.isEmpty) {
      onPanStart(point);
      return;
    }
    final DrawingStroke last = strokes.last;
    final Offset previous = last.points.last;
    final double distance = (point - previous).distance;
    final double minStep =
        last.tool == DrawingTool.spray ? 6.0 : 1.0;
    if (distance < minStep) {
      return;
    }
    strokes[lastIndex] = DrawingStroke(
      points: <Offset>[...last.points, point],
      color: last.color,
      width: last.width,
      tool: last.tool,
    );
    update([canvasId]);
  }

  void onPanEnd() {
    update([canvasId]);
  }

  void undo() {
    if (!canUndo) {
      return;
    }
    redoStack.add(strokes.removeLast());
    update([canvasId]);
  }

  void redo() {
    if (!canRedo) {
      return;
    }
    strokes.add(redoStack.removeLast());
    update([canvasId]);
  }

  /// Label of the current brush size for the pill next to the slider.
  String get brushSizeLabel {
    if (brushWidth.value < 6) {
      return 'رفيعة';
    }
    if (brushWidth.value <= 11) {
      return 'متوسطة';
    }
    return 'عريضة';
  }

  // TODO: swap this preview-save for a real repository write.
  void onSavePressed() {
    AppSnackbar.success('تم الحفظ (معاينة)');
  }

  // TODO: replace with the real stickers picker screen.
  void onStickersPressed() {
    AppSnackbar.info('قريباً');
  }

  /// Pen draws a thin solid line; brush and spray follow the size slider.
  double _effectiveWidth() {
    switch (selectedTool.value) {
      case DrawingTool.pen:
        return 3;
      case DrawingTool.brush:
      case DrawingTool.spray:
        return brushWidth.value;
    }
  }

  int get lastIndex => strokes.length - 1;
}
