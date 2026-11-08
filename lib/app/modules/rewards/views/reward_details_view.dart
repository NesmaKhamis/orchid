import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../controllers/reward_details_controller.dart';

class RewardDetailsView extends GetView<RewardDetailsController> {
  const RewardDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      title: controller.reward.title,
      showBackButton: true,
      body: Center(
        child: Text(controller.reward.title, style: AppTextStyles.h2),
      ),
    );
  }
}
