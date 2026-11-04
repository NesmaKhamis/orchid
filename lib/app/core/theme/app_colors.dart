import 'package:flutter/material.dart';

/// Color tokens from AGENTS.md section 5.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF8B53A8);
  static const Color textDark = Color(0xFF2D2D2D);
  static const Color textSubtitle = Color(0xFF6B588C);
  static const Color textMuted = Color(0xFF757575);
  static const Color inputBg = Color(0xFFFAF9FC);
  static const Color border = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFFAFAF2);
  static const Color lavender = Color(0xFFF0E0F0);
  static const Color softYellow = Color(0xFFF8F0C8);
  static const Color softMint = Color(0xFFE0F0E0);
  static const Color softPink = Color(0xFFF0D8E8);
  static const Color softBlue = Color(0xFFE0E8F0);
  static const Color error = Color(0xFFD32F2F);

  // Drawing palette (kid marker colors for the free-drawing canvas).
  static const Color palettePink = Color(0xFFE86A92);
  static const Color paletteYellow = Color(0xFFF5C542);
  static const Color paletteGreen = Color(0xFF58B368);
  static const Color paletteBlue = Color(0xFF4E7AC7);
  static const Color paletteNavy = Color(0xFF2D3A5E);

  /// Shared kid-marker palette for the drawing and coloring canvases.
  static const List<Color> canvasPalette = <Color>[
    primary,
    palettePink,
    paletteYellow,
    paletteGreen,
    paletteBlue,
    paletteNavy,
  ];

  static const List<Color> splashGradient = <Color>[
    Color(0xFFD8F3DC),
    Color(0xFFE8E8F4),
    Color(0xFFFFF0F5),
  ];
}
