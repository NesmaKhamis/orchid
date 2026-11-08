import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';
import 'app_back_button.dart';

/// Screen top bar: back button at the start, caption above a bold title,
/// and an optional trailing widget (e.g. sound toggle) at the end.
class AppHeaderBar extends StatelessWidget {
  const AppHeaderBar({
    super.key,
    required this.title,
    this.caption,
    this.trailing,
    this.onBackPressed,
  });

  final String title;
  final String? caption;
  final Widget? trailing;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppDimens.screenHorizontalPadding,
      ),
      child: SizedBox(
        height: 48,
        child: Row(
          children: <Widget>[
            AppBackButton(onPressed: onBackPressed),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  if (caption != null) ...<Widget>[
                    Text(
                      caption!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space4),
                  ],
                  Text(
                    title,
                    style: AppTextStyles.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing! else const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
