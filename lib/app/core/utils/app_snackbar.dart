import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

/// The only way to show snackbars.
class AppSnackbar {
  AppSnackbar._();

  static void info(String message) {
    _show(message, AppColors.lavender, AppColors.textDark);
  }

  static void success(String message) {
    _show(message, AppColors.softMint, AppColors.textDark);
  }

  static void warning(String message) {
    _show(message, AppColors.softYellow, AppColors.textDark);
  }

  static void error(String message) {
    _show(message, AppColors.softPink, AppColors.error);
  }

  static void _show(String message, Color backgroundColor, Color textColor) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
      colorText: textColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
