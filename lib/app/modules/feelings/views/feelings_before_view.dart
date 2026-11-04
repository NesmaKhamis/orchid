import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../routes/app_routes.dart';

class FeelingsBeforeView extends StatelessWidget {
  const FeelingsBeforeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      background: AppScaffoldBackground.cream,
      body: Center(
        child: Text(
          'شاشة المشاعر — قبل\n${Routes.feelingsBefore}',
          textAlign: TextAlign.center,
          style: AppTextStyles.title,
        ),
      ),
    );
  }
}
