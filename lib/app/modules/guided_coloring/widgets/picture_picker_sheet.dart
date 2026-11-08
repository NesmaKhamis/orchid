import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../data/models/coloring_picture.dart';
import '../controllers/guided_coloring_controller.dart';
import 'coloring_painter.dart';

/// Bottom sheet with a grid of all pictures to choose from.
class PicturePickerSheet extends StatelessWidget {
  const PicturePickerSheet({super.key});

  Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusCard),
        ),
      ),
      builder: (BuildContext context) => const Directionality(
        textDirection: TextDirection.rtl,
        child: PicturePickerSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GuidedColoringController controller =
        Get.find<GuidedColoringController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.space16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'اختر لوحة',
              textAlign: TextAlign.center,
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppDimens.space16),
            SizedBox(
              height: 420,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: AppDimens.space12,
                  crossAxisSpacing: AppDimens.space12,
                  childAspectRatio: 0.85,
                ),
                itemCount: controller.pictures.length,
                itemBuilder: (BuildContext context, int index) {
                  final ColoringPicture picture =
                      controller.pictures[index];
                  return _PictureTile(picture: picture);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PictureTile extends StatelessWidget {
  const _PictureTile({required this.picture});

  final ColoringPicture picture;

  @override
  Widget build(BuildContext context) {
    final GuidedColoringController controller =
        Get.find<GuidedColoringController>();

    return GestureDetector(
      onTap: () {
        controller.selectPicture(picture.id);
        Get.back();
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppDimens.radiusField),
                border: Border.all(color: AppColors.border),
              ),
              padding: const EdgeInsets.all(AppDimens.space8),
              child: CustomPaint(
                size: Size.infinite,
                painter: ColoringPainter(
                  picture: picture,
                  fills: const <String, Color>{},
                  fadeFrom: const <String, Color?>{},
                  fadeProgress: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimens.space4),
          Text(
            picture.name,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

