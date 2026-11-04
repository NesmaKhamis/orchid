import '../models/coloring_picture.dart';

/// Source of guided-coloring pictures.
abstract class ColoringRepository {
  List<ColoringPicture> getPictures();
}
