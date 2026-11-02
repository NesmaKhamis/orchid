import 'package:flutter/material.dart';

import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Centered title with optional emoji and subtitle.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.emoji,
    this.subtitle,
  });

  final String title;
  final String? emoji;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (emoji != null) ...<Widget>[
              Text(
                emoji!,
                style: AppTextStyles.h2,
              ),
              const SizedBox(width: AppDimens.space8),
            ],
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2,
              ),
            ),
          ],
        ),
        if (subtitle != null && subtitle!.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppDimens.space8),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        ],
      ],
    );
  }
}
