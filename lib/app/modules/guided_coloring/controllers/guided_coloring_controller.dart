import 'package:flutter/material.dart' show Color, Colors, Offset, Size;
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/coloring_action.dart';
import '../../../data/models/coloring_picture.dart';
import '../../../data/repositories/coloring_repository.dart';

/// Controller for the guided coloring screen (التلوين الموجه).
class GuidedColoringController extends GetxController {
  GuidedColoringController({required ColoringRepository repository})
      : _repository = repository;

  final ColoringRepository _repository;

  late final List<ColoringPicture> pictures;
  final List<String> categories = <String>[];

  final selectedCategory = ''.obs;
  final currentPicture = Rxn<ColoringPicture>();
  final fills = RxMap<String, Color>();
  final selectedColor = AppColors.primary.obs;
  final isMuted = false.obs;
  final undoStack = <ColoringAction>[].obs;
  final redoStack = <ColoringAction>[].obs;

  /// Regions currently fading in: regionId -> color before the fill.
  final fadeFrom = RxMap<String, Color?>();

  /// Bumped on every canvas change so the canvas can restart its fade.
  final fillStamp = 0.obs;

  final Map<String, String> _categorySelection = <String, String>{};

  @override
  void onInit() {
    super.onInit();
    pictures = _repository.getPictures();
    for (final ColoringPicture picture in pictures) {
      if (!categories.contains(picture.category)) {
        categories.add(picture.category);
      }
    }
    selectCategory(categories.first);
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    final String pictureId = _categorySelection[category] ??
        pictures
            .firstWhere((ColoringPicture p) => p.category == category)
            .id;
    _setPicture(pictureId);
  }

  void selectPicture(String id) {
    final ColoringPicture picture =
        pictures.firstWhere((ColoringPicture p) => p.id == id);
    _categorySelection[picture.category] = id;
    _setPicture(id);
  }

  /// Switching picture resets the canvas (fills and history).
  void _setPicture(String id) {
    currentPicture.value =
        pictures.firstWhere((ColoringPicture p) => p.id == id);
    fills.clear();
    undoStack.clear();
    redoStack.clear();
    fadeFrom.clear();
    fillStamp.value++;
  }

  void selectColor(Color color) {
    selectedColor.value = color;
  }

  void toggleSound() {
    isMuted.value = !isMuted.value;
  }

  bool get canUndo => undoStack.isNotEmpty;

  bool get canRedo => redoStack.isNotEmpty;

  /// Tap-fill: finds the region under the normalized tap point.
  void onCanvasTap(Offset position, Size canvasSize) {
    final ColoringPicture? picture = currentPicture.value;
    if (picture == null || canvasSize.width == 0) {
      return;
    }
    final Offset normalized = Offset(
      position.dx / canvasSize.width,
      position.dy / canvasSize.height,
    );
    for (final region in picture.regions) {
      if (region.path.contains(normalized)) {
        _fillRegion(region.id, selectedColor.value);
        return;
      }
    }
    // Tapping outside any region does nothing.
  }

  /// Smart fill: fills all unfilled regions with a harmonious sequence.
  void smartFill() {
    final ColoringPicture? picture = currentPicture.value;
    if (picture == null) {
      return;
    }
    final List<Color> harmony = <Color>[
      AppColors.palettePink,
      AppColors.paletteYellow,
      AppColors.paletteGreen,
      AppColors.paletteBlue,
      AppColors.primary,
    ];
    final List<ColoringFillStep> steps = <ColoringFillStep>[];
    final Map<String, Color?> fading = <String, Color?>{};
    int i = 0;
    for (final region in picture.regions) {
      if (fills.containsKey(region.id)) {
        continue;
      }
      final Color newColor = harmony[i % harmony.length];
      steps.add(ColoringFillStep(
        regionId: region.id,
        previousColor: fills[region.id],
        newColor: newColor,
      ));
      fading[region.id] = Colors.white;
      fills[region.id] = newColor;
      i++;
    }
    if (steps.isEmpty) {
      return;
    }
    undoStack.add(steps);
    redoStack.clear();
    fadeFrom.clear();
    fadeFrom.addAll(fading);
    fillStamp.value++;
  }

  void undo() {
    if (!canUndo) {
      return;
    }
    final ColoringAction action = undoStack.removeLast();
    for (final ColoringFillStep step in action) {
      _applyFill(step.regionId, step.previousColor);
    }
    redoStack.add(action);
    fadeFrom.clear();
    fillStamp.value++;
  }

  void redo() {
    if (!canRedo) {
      return;
    }
    final ColoringAction action = redoStack.removeLast();
    for (final ColoringFillStep step in action) {
      _applyFill(step.regionId, step.newColor);
    }
    undoStack.add(action);
    fadeFrom.clear();
    fillStamp.value++;
  }

  // TODO: swap this preview-save for a real repository write.
  void onSavePressed() {
    AppSnackbar.success('تم الحفظ (معاينة)');
  }

  void _fillRegion(String regionId, Color newColor) {
    final Color? previous = fills[regionId];
    if (previous == newColor) {
      return;
    }
    _applyFill(regionId, newColor);
    undoStack.add(<ColoringFillStep>[
      ColoringFillStep(
        regionId: regionId,
        previousColor: previous,
        newColor: newColor,
      ),
    ]);
    redoStack.clear();
    fadeFrom.clear();
    fadeFrom[regionId] = previous ?? Colors.white;
    fillStamp.value++;
  }

  void _applyFill(String regionId, Color? color) {
    if (color == null) {
      fills.remove(regionId);
    } else {
      fills[regionId] = color;
    }
  }
}

