import '../models/song.dart';

/// Source of songs for the singing screen.
abstract class SongRepository {
  List<Song> getSongs();
}
