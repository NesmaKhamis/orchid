import 'package:flutter/material.dart' show Color, IconData;

/// A kids' chant shown on the singing screen (حديقة الأصوات).
class Song {
  const Song({
    required this.id,
    required this.title,
    required this.durationSeconds,
    required this.description,
    required this.icon,
    required this.color,
    required this.audioAsset,
    required this.verses,
  });

  final String id;
  final String title;
  final int durationSeconds;
  final String description;
  final IconData icon;
  final Color color;

  /// TODO: real audio file path (to be added to assets and pubspec later).
  final String audioAsset;

  /// Chant verses (each = a short list of lines: 2 emphasized + 2 softer).
  /// Swipeable on the recording screen, one verse per page.
  final List<List<String>> verses;
}
