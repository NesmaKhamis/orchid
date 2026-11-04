import 'coloring_region.dart';

/// A guided-coloring picture: outline regions the child can tap-fill.
class ColoringPicture {
  const ColoringPicture({
    required this.id,
    required this.name,
    required this.title,
    required this.category,
    required this.instruction,
    required this.regions,
  });

  final String id;

  /// Short name shown next to the selected category chip (e.g. "فراشة").
  final String name;

  /// Display title shown in the header (e.g. "فراشة في حديقتي").
  final String title;
  final String category;
  final String instruction;
  final List<ColoringRegion> regions;
}
