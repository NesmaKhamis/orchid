import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/drawing_tool.dart';
import '../controllers/drawing_controller.dart';

/// Color swatches, tool tiles, and the brush size slider.
class DrawingToolbar extends StatelessWidget {
  const DrawingToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const _ColorRow(),
        const SizedBox(height: AppDimens.space16),
        const _ToolRow(),
        const SizedBox(height: AppDimens.space16),
        const _BrushSizeRow(),
      ],
    );
  }
}

class _ColorRow extends StatelessWidget {
  const _ColorRow();

  @override
  Widget build(BuildContext context) {
    final DrawingController controller = Get.find<DrawingController>();

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (final Color color in AppColors.canvasPalette)
            GestureDetector(
              onTap: () => controller.selectColor(color),
              child: _Swatch(
                color: color,
                isSelected: controller.selectedColor.value == color,
              ),
            ),
        ],
      ),
    );
  }
}

/// Circular swatch; the selected one gets a subtle same-color ring.
class _Swatch extends StatelessWidget {
  const _Swatch({required this.color, required this.isSelected});

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow();

  @override
  Widget build(BuildContext context) {
    final DrawingController controller = Get.find<DrawingController>();

    return Obx(
      () => Row(
        children: <Widget>[
          Expanded(
            child: _ToolTile(
              icon: Icons.edit_rounded,
              label: 'قلم',
              isSelected: controller.selectedTool.value == DrawingTool.pen,
              onTap: () => controller.selectTool(DrawingTool.pen),
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: _ToolTile(
              icon: Icons.brush_rounded,
              label: 'فرشاة',
              isSelected: controller.selectedTool.value == DrawingTool.brush,
              onTap: () => controller.selectTool(DrawingTool.brush),
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: _ToolTile(
              icon: Icons.scatter_plot_rounded,
              label: 'رش ألوان',
              isSelected: controller.selectedTool.value == DrawingTool.spray,
              onTap: () => controller.selectTool(DrawingTool.spray),
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: _ToolTile(
              icon: Icons.sticky_note_2_rounded,
              label: 'ملصقات',
              isSelected: false,
              onTap: controller.onStickersPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimens.space12,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavender : Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusField),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 22,
              color:
                  isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: AppDimens.space4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color:
                    isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrushSizeRow extends StatelessWidget {
  const _BrushSizeRow();

  @override
  Widget build(BuildContext context) {
    final DrawingController controller = Get.find<DrawingController>();

    return Obx(
      () => Row(
        children: <Widget>[
          const Text(
            'حجم الفرشاة',
            style: AppTextStyles.bodySmall,
          ),
          Expanded(
            child: Slider(
              value: controller.brushWidth.value,
              min: DrawingController.brushMinSize,
              max: DrawingController.brushMaxSize,
              divisions: (DrawingController.brushMaxSize -
                      DrawingController.brushMinSize)
                  .round(),
              activeColor: AppColors.primary,
              onChanged: controller.setBrushWidth,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space12,
              vertical: AppDimens.space4,
            ),
            decoration: BoxDecoration(
              color: AppColors.lavender,
              borderRadius: BorderRadius.circular(AppDimens.radiusChip),
            ),
            child: Text(
              '${controller.brushSizeLabel} • ${controller.brushWidth.value.round()}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
