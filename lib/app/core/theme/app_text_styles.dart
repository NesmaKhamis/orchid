import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Unified typography scale tokens.
class AppTextStyles {
  AppTextStyles._();

  /// Tab and top-level screen header titles (Home, Rewards, Workshops, Profile, Notifications).
  static const TextStyle tabTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Backward-compatible alias for tabTitle.
  static const TextStyle display = tabTitle;
  static const TextStyle h1Large = tabTitle;

  /// Top display / splash titles.
  static const TextStyle h1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Subtitle directly below tab header titles.
  static const TextStyle tabSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSubtitle,
  );

  /// Major screen and section titles (step headers, dialog headers, section headers).
  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Backward-compatible aliases for sectionTitle.
  static const TextStyle title = sectionTitle;
  static const TextStyle h2 = sectionTitle;
  static const TextStyle h2Large = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Primary card headers (Home cards, workshop cards, reward items).
  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Backward-compatible alias for cardTitle.
  static const TextStyle bodyLarge = cardTitle;

  /// Primary action button labels.
  static const TextStyle buttonLabel = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Standard body copy, input text, dialog text.
  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );

  /// Backward-compatible alias for body.
  static const TextStyle subtitle = body;

  /// Secondary body text, info rows, descriptions.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    color: AppColors.textDark,
  );

  /// Badges, tags, form field labels, chip texts.
  static const TextStyle chipLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  /// Backward-compatible alias for chipLabel.
  static const TextStyle label = chipLabel;

  /// Small metadata, timestamps, captions, badge texts.
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textDark,
  );
}
