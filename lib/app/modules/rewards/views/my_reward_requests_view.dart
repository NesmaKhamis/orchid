import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../controllers/my_reward_requests_controller.dart';

class MyRewardRequestsView extends GetView<MyRewardRequestsController> {
  const MyRewardRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      background: AppScaffoldBackground.cream,
      title: 'طلباتي من المكافآت',
      showBackButton: true,
      body: Center(
        child: Text('طلباتي', style: AppTextStyles.h2),
      ),
    );
  }
}
