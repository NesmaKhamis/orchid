import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Image.asset with built-in fallback icon.
class OrchidImage extends StatelessWidget {
  const OrchidImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (
        BuildContext context,
        Object error,
        StackTrace? stackTrace,
      ) {
        return Icon(
          Icons.local_florist_outlined,
          color: AppColors.primary,
          size: width ?? height ?? 40,
        );
      },
    );
  }
}
