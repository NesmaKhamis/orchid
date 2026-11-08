import 'package:flutter/material.dart';

import '../constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimens.dart';
import 'app_back_button.dart';

/// Screen shell with RTL directionality.
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.background = AppScaffoldBackground.plain,
    this.showCornerLeaf = false,
    this.scrollable = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppDimens.screenHorizontalPadding,
    ),
    this.title,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final Widget body;
  final AppScaffoldBackground background;
  final bool showCornerLeaf;
  final bool scrollable;
  final EdgeInsetsGeometry padding;
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    Widget content = body;
    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    Widget scaffoldBody = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null || showBackButton) _buildAppBar(context),
          Expanded(child: content),
        ],
      ),
    );

    if (showCornerLeaf) {
      scaffoldBody = Stack(
        children: <Widget>[
          scaffoldBody,
          PositionedDirectional(
            start: 0,
            top: 0,
            child: SafeArea(
              child: Image.asset(
                AppAssets.leafCorner,
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _backgroundColor(),
        body: SafeArea(child: scaffoldBody),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space16),
      child: Row(
        children: <Widget>[
          if (showBackButton)
            AppBackButton(onPressed: onBackPressed)
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Color _backgroundColor() {
    switch (background) {
      case AppScaffoldBackground.plain:
        return Colors.white;
      case AppScaffoldBackground.cream:
        return AppColors.background;
      case AppScaffoldBackground.gradient:
        return Colors.white;
    }
  }
}

enum AppScaffoldBackground { plain, cream, gradient }
