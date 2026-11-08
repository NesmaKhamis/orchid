import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';

/// Shared back action that always renders the Arabic back arrow pointing right.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: IconButton(
        onPressed: onPressed ?? Get.back,
        icon: const Icon(Icons.arrow_forward_rounded),
        color: AppColors.textDark,
        iconSize: 24,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      ),
    );
  }
}