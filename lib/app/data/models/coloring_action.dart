import 'dart:ui' show Color;

/// One region fill change (previous color may be null = unfilled).
class ColoringFillStep {
  const ColoringFillStep({
    required this.regionId,
    required this.previousColor,
    required this.newColor,
  });

  final String regionId;
  final Color? previousColor;
  final Color newColor;
}

/// An undo/redo unit: a tap fills one step, smart-fill batches many.
typedef ColoringAction = List<ColoringFillStep>;
