import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Text style tokens.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle display = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle h1Large = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle h1 = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle h2Large = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: AppColors.textDark,
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: AppColors.textDark,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
  );
}
