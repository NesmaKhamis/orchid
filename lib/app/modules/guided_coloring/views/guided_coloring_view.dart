import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../controllers/guided_coloring_controller.dart';
import '../widgets/coloring_canvas_widget.dart';
import '../widgets/picture_picker_sheet.dart';

/// Screen: "التلوين الموجه" — tap-fill guided coloring pictures.
class GuidedColoringView extends StatelessWidget {
  const GuidedColoringView({super.key});

  @override
  Widget build(BuildContext context) {
    final GuidedColoringController controller =
        Get.find<GuidedColoringController>();

    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Obx(
            () => AppHeaderBar(
              caption: '05 / عبّر عن نفسك • التلوين الموجه',
              title: controller.currentPicture.value?.title ?? '',
              trailing: const _SoundToggle(),
              onBackPressed: Get.back,
            ),
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
                    const _CategoryChipsRow(),
                    const SizedBox(height: AppDimens.space8),
                    Obx(
                      () => Text(
                        controller.currentPicture.value?.instruction ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space12),
                    const ColoringCanvasWidget(),
                    const SizedBox(height: AppDimens.space16),
                    const _ColorDotsRow(),
                    const SizedBox(height: AppDimens.space16),
                    const _SmartFillRow(),
                    const SizedBox(height: AppDimens.space16),
                    const NoticeBanner(
                      tone: NoticeBannerTone.success,
                      icon: Icon(
                        Icons.auto_awesome_rounded,
                        size: 20,
                        color: AppColors.textSubtitle,
                      ),
                      text: 'يا له من اختيار جميل! لا تحتاج للبقاء داخل '
                          'الخطوط، يمكنك دائماً المحاولة بلون آخر.',
                    ),
                    const SizedBox(height: AppDimens.space16),
                    AppButton(
                      label: 'حفظ لوحتي • معاينة',
                      icon: const Icon(Icons.bookmark_rounded, size: 20),
                      onPressed: controller.onSavePressed,
                    ),
                    const SizedBox(height: AppDimens.space8),
                    AppButton(
                      label: 'اختيار لوحة أخرى',
                      variant: AppButtonVariant.soft,
                      onPressed: () =>
                          const PicturePickerSheet().show(context),
                    ),
                    const SizedBox(height: AppDimens.space24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChipsRow extends StatelessWidget {
  const _CategoryChipsRow();

  @override
  Widget build(BuildContext context) {
    final GuidedColoringController controller =
        Get.find<GuidedColoringController>();

    return Obx(
      () => Row(
        children: <Widget>[
          for (final String category in controller.categories) ...<Widget>[
            Expanded(
              child: _CategoryChip(
                category: category,
                pictureName: controller.currentPicture.value?.name ?? '',
                isSelected:
                    controller.selectedCategory.value == category,
                onTap: () => controller.selectCategory(category),
              ),
            ),
            const SizedBox(width: AppDimens.space8),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.pictureName,
    required this.isSelected,
    required this.onTap,
  });

  final String category;
  final String pictureName;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String label =
        isSelected ? '$category • $pictureName' : category;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.space8,
          horizontal: AppDimens.space4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusChip),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: isSelected ? Colors.white : AppColors.textDark,
          ),
        ),
      ),
    );
  }
}

class _ColorDotsRow extends StatelessWidget {
  const _ColorDotsRow();

  @override
  Widget build(BuildContext context) {
    final GuidedColoringController controller =
        Get.find<GuidedColoringController>();

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (final Color color in AppColors.canvasPalette)
            _ColorDot(
              color: color,
              isSelected: controller.selectedColor.value == color,
              onTap: () => controller.selectColor(color),
            ),
        ],
      ),
    );
  }
}

/// Circular swatch; the selected one gets a subtle same-color ring.
class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(AppDimens.space4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _SmartFillRow extends StatelessWidget {
  const _SmartFillRow();

  @override
  Widget build(BuildContext context) {
    final GuidedColoringController controller =
        Get.find<GuidedColoringController>();

    return Row(
      children: <Widget>[
        Expanded(
          child: AppButton(
            label: 'التعبئة الذكية',
            variant: AppButtonVariant.soft,
            icon: const Icon(Icons.auto_fix_high_rounded, size: 20),
            onPressed: controller.smartFill,
          ),
        ),
        const SizedBox(width: AppDimens.space8),
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
    );
  }
}

class _SoundToggle extends StatelessWidget {
  const _SoundToggle();

  @override
  Widget build(BuildContext context) {
    final GuidedColoringController controller =
        Get.find<GuidedColoringController>();

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

