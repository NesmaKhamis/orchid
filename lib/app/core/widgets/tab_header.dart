import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import '../theme/app_text_styles.dart';

/// Unified header for main shell tabs (Home, Rewards, Workshops).
///
/// Features identical typography, consistent top/bottom spacing,
/// and trailing alignment so tab headers share consistent layout.
class TabHeader extends StatelessWidget {
  const TabHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
        top: AppDimens.space40,
        bottom: AppDimens.space20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: AppTextStyles.display,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...<Widget>[
                  const SizedBox(height: AppDimens.space4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.tabSubtitle.copyWith(
                      color: AppColors.textSubtitle,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimens.space12),
          trailing ?? const SizedBox(width: 44, height: 44),
        ],
      ),
    );
  }
}
