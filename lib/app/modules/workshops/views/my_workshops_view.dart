import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../controllers/my_workshops_controller.dart';
import '../widgets/my_bookings_section.dart';

class MyWorkshopsView extends GetView<MyWorkshopsController> {
  const MyWorkshopsView({super.key});

  @override
  Widget build(BuildContext context) {
    final double bottomScrollPadding = AppDimens.floatingNavBarTotalHeight +
        MediaQuery.paddingOf(context).bottom +
        AppDimens.space24;

    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppHeaderBar(title: 'ورشاتي المسجلة', onBackPressed: Get.back),
          Expanded(
            child: Obx(
              () => MyBookingsSection(
                workshops: controller.workshops,
                isLoading: controller.isLoading.value,
                hasError: controller.hasError.value,
                cancellingWorkshopId: controller.cancellingWorkshopId.value,
                onRetry: controller.loadBookedWorkshops,
                onDetailsPressed: controller.openDetails,
                onCancelPressed: controller.cancelBooking,
                bottomScrollPadding: bottomScrollPadding,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
