import 'dart:ui' show Path;

/// A tappable region of a coloring picture.
/// The path is normalized to a 0..1 square and scaled to the canvas.
class ColoringRegion {
  const ColoringRegion({required this.id, required this.path});

  final String id;
  final Path path;
}
