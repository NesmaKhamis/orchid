import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../controllers/express_yourself_controller.dart';
import '../widgets/animated_activity_card.dart';
import '../widgets/floating_background.dart';
import '../widgets/mascot_greeting.dart';

/// Screen: "عَبِّر عن نفسك" — the child picks a creative activity.
class ExpressYourselfView extends GetView<ExpressYourselfController> {
  const ExpressYourselfView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  AppColors.background,
                  Color.lerp(AppColors.background, AppColors.lavender, 0.36)!,
                ],
              ),
            ),
          ),
          const FloatingBackground(),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: SizedBox(
                width: double.infinity,
                child: _ExpressYourselfContent(controller: controller),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpressYourselfContent extends StatefulWidget {
  const _ExpressYourselfContent({required this.controller});

  final ExpressYourselfController controller;

  @override
  State<_ExpressYourselfContent> createState() =>
      _ExpressYourselfContentState();
}

class _ExpressYourselfContentState extends State<_ExpressYourselfContent> {
  final GlobalKey<MascotGreetingState> _mascotKey =
      GlobalKey<MascotGreetingState>();

  void _showCardMessage(String message) {
    _mascotKey.currentState?.showMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                MascotGreeting(
                  key: _mascotKey,
                  onMascotTapped: widget.controller.onMascotTapped,
                ),
                const SizedBox(height: AppDimens.space24),
                AnimatedActivityCard(
                  index: 0,
                  floatPhase: 0,
                  backgroundColor: AppColors.softPink,
                  icon: Icons.brush_rounded,
                  title: 'الرسم الحر',
                  subtitle: 'خطوطك تحكي حكايتك',
                  onPressedDown: () => _showCardMessage('يلا نرسم حكايتك!'),
                  onTap: widget.controller.onFreeDrawingPressed,
                ),
                const SizedBox(height: AppDimens.space16),
                AnimatedActivityCard(
                  index: 1,
                  floatPhase: 0.34,
                  backgroundColor: AppColors.softMint,
                  icon: Icons.local_florist_rounded,
                  title: 'التلوين الموجه',
                  subtitle: 'ألوان صغيرة… وراحة كبيرة',
                  onPressedDown: () =>
                      _showCardMessage('ألوان هادية وراحة كبيرة'),
                  onTap: widget.controller.onGuidedColoringPressed,
                ),
                const SizedBox(height: AppDimens.space16),
                AnimatedActivityCard(
                  index: 2,
                  floatPhase: 0.68,
                  backgroundColor: AppColors.lavender,
                  icon: Icons.music_note_rounded,
                  title: 'الغناء والإنشاد',
                  subtitle: 'صوتك له مكان آمن',
                  onPressedDown: () => _showCardMessage('صوتك له مكان آمن'),
                  onTap: widget.controller.onSingingPressed,
                ),
                const SizedBox(height: AppDimens.space24),
                const Padding(
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.screenHorizontalPadding,
                  ),
                  child: NoticeBanner(
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
                ),
                const SizedBox(height: AppDimens.space24),
              ],
            ),
          ),
        ),
      ],
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
