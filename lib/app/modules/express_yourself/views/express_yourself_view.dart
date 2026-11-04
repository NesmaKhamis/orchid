import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/orchid_image.dart';
import '../controllers/express_yourself_controller.dart';

/// Screen: "عَبِّر عن نفسك" — the child picks a creative activity.
class ExpressYourselfView extends GetView<ExpressYourselfController> {
  const ExpressYourselfView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppHeaderBar(
            caption: '04 / حديقة الإبداع',
            title: 'عَبِّر عن نفسك',
            trailing: const _SoundToggle(),
            onBackPressed: Get.back,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _GreetingRow(),
                  const SizedBox(height: AppDimens.space24),
                  _ActivityCard(
                    backgroundColor: AppColors.softPink,
                    icon: Icons.brush_rounded,
                    title: 'الرسم الحر',
                    subtitle: 'خطوطك تحكي حكايتك',
                    onTap: controller.onFreeDrawingPressed,
                  ),
                  const SizedBox(height: AppDimens.space16),
                  _ActivityCard(
                    backgroundColor: AppColors.softMint,
                    icon: Icons.local_florist_rounded,
                    title: 'التلوين الموجه',
                    subtitle: 'ألوان صغيرة… وراحة كبيرة',
                    onTap: controller.onGuidedColoringPressed,
                  ),
                  const SizedBox(height: AppDimens.space16),
                  _ActivityCard(
                    backgroundColor: AppColors.lavender,
                    icon: Icons.music_note_rounded,
                    title: 'الغناء والإنشاد',
                    subtitle: 'صوتك له مكان آمن',
                    onTap: controller.onSingingPressed,
                  ),
                  const SizedBox(height: AppDimens.space24),
                  const NoticeBanner(
                    tone: NoticeBannerTone.info,
                    icon: Icon(
                      Icons.lock_outline_rounded,
                      size: 20,
                      color: AppColors.textSubtitle,
                    ),
                    text:
                        'أعمالك لك وحدك، وأمرك فيها فقط. لا مشاركة عامة '
                        'ولا مقارنات مع الآخرين.',
                  ),
                  const SizedBox(height: AppDimens.space24),
                ],
              ),
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
    final ExpressYourselfController controller =
        Get.find<ExpressYourselfController>();

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

/// Greeting: text at the start (right in RTL), flower character at the end.
class _GreetingRow extends StatelessWidget {
  const _GreetingRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppDimens.screenHorizontalPadding,
      ),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ما الذي تحبّه اليوم؟',
                  style: AppTextStyles.title,
                ),
                SizedBox(height: AppDimens.space4),
                Text(
                  'لا توجد طريقة خاطئة للتعبير.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.space16),
          // TODO: replace with the dedicated flower character asset when
          // the designer exports it (add it to AppAssets, do not hardcode).
          const OrchidImage(
            assetPath: AppAssets.orchidSingle,
            width: 64,
            height: 64,
          ),
        ],
      ),
    );
  }
}

/// Reusable tappable activity card with a subtle press scale animation.
class _ActivityCard extends StatefulWidget {
  const _ActivityCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  State<_ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<_ActivityCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppDimens.screenHorizontalPadding,
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.space16),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(AppDimens.space12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppDimens.radiusField)),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppDimens.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: AppTextStyles.label,
                      ),
                      const SizedBox(height: AppDimens.space4),
                      Text(
                        widget.subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.space8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: AppColors.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
