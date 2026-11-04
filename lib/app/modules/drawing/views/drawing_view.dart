import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../controllers/drawing_controller.dart';
import '../widgets/drawing_canvas_widget.dart';
import '../widgets/drawing_toolbar.dart';

/// Screen: "مرسمي الصغير" — free drawing canvas with colors and tools.
class DrawingView extends GetView<DrawingController> {
  const DrawingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AppHeaderBar(
              caption: '04 / عبّر عن نفسك • الرسم الحر',
              title: 'مرسمي الصغير',
              trailing: const _SoundToggle(),
              onBackPressed: Get.back,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.screenHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const _CanvasTitleRow(),
                      const DrawingCanvasWidget(),
                      const SizedBox(height: AppDimens.space16),
                      const DrawingToolbar(),
                      const SizedBox(height: AppDimens.space16),
                      AppButton(
                        label: 'حفظ في أعمالي • معاينة',
                        icon: const Icon(
                          Icons.bookmark_rounded,
                          size: 20,
                        ),
                        onPressed: controller.onSavePressed,
                      ),
                      const SizedBox(height: AppDimens.space8),
                      Text(
                        'مساحتك الخاصة. الحفظ المعروض حالة تصميم، لا تخزين فعلي.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppDimens.space24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Row above the canvas: "حديقتي السعيدة" plus undo/redo.
class _CanvasTitleRow extends StatelessWidget {
  const _CanvasTitleRow();

  @override
  Widget build(BuildContext context) {
    final DrawingController controller = Get.find<DrawingController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space12),
      child: Row(
        children: <Widget>[
          const Text(
            'حديقتي السعيدة',
            style: AppTextStyles.label,
          ),
          const Spacer(),
          Obx(
            () => IconButton(
              onPressed: controller.undo,
              icon: const Icon(Icons.undo_rounded),
              color: controller.canUndo
                  ? AppColors.primary
                  : AppColors.textMuted.withValues(alpha: 0.4),
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: controller.redo,
              icon: const Icon(Icons.redo_rounded),
              color: controller.canRedo
                  ? AppColors.primary
                  : AppColors.textMuted.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Sound toggle shown in the header (UI only).
class _SoundToggle extends StatelessWidget {
  const _SoundToggle();

  @override
  Widget build(BuildContext context) {
    final DrawingController controller = Get.find<DrawingController>();

    return Obx(
      () => IconButton(
        // UI-only toggle until audio playback is wired.
        onPressed: controller.toggleSound,
        icon: Icon(
          controller.isMuted.value
              ? Icons.volume_off_rounded
              : Icons.volume_up_rounded,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
