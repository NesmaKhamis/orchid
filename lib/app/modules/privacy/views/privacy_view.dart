import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../routes/app_routes.dart';

class PrivacyView extends StatelessWidget {
  const PrivacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: Center(
        child: Text(
          'شاشة الخصوصية\n${Routes.privacy}',
          textAlign: TextAlign.center,
          style: AppTextStyles.title,
        ),
      ),
    );
  }
}
