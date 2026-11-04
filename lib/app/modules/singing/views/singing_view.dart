import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../core/widgets/orchid_image.dart';
import '../controllers/singing_controller.dart';
import '../../../data/models/song.dart';

/// Screen: "حديقة الأصوات" — songs, nature backgrounds, and recording.
class SingingView extends GetView<SingingController> {
  const SingingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AppHeaderBar(
            caption: '05 / الغناء والإنشاد',
            title: 'حديقة الأصوات',
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
                    const _GreetingRow(),
                    const SizedBox(height: AppDimens.space12),
                    Text(
                      'كلمات مهدئة وسهلة. اختر نشيداً، واستمع ثم غنِّ معه '
                      'دون تقييم لصوتك.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space16),
                    for (final Song song in controller.songs) ...<Widget>[
                      _SongCard(song: song),
                      const SizedBox(height: AppDimens.space12),
                    ],
                    const _BackgroundsSection(),
                    const SizedBox(height: AppDimens.space16),
                    const _RecordButton(),
                    const SizedBox(height: AppDimens.space8),
                    const NoticeBanner(
                      tone: NoticeBannerTone.info,
                      icon: Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: AppColors.textSubtitle,
                      ),
                      text: 'التسجيلات خاصة بالطفل ووليّ أمره. '
                          'لا يوجد نشر أو مشاركة عامة.',
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

/// Greeting: text at the start (right in RTL), flower character at the end.
class _GreetingRow extends StatelessWidget {
  const _GreetingRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'غنِّ كما أنت…',
                style: AppTextStyles.title,
              ),
              SizedBox(height: AppDimens.space4),
              Text(
                'صوتك جميل بطريقته.',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppDimens.space16),
        // Same flower illustration as the ExpressYourselfScreen.
        const OrchidImage(
          assetPath: AppAssets.orchidSingle,
          width: 64,
          height: 64,
        ),
      ],
    );
  }
}

/// Song card: icon tile at the start, title/duration, play circle at the end.
class _SongCard extends StatelessWidget {
  const _SongCard({required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final SingingController controller = Get.find<SingingController>();

    return Obx(
      () {
        final bool isPlaying = controller.isSongPlaying(song);

        return GestureDetector(
          // Whole card navigates to the recording screen.
          onTap: () => controller.onSongCardPressed(song),
          child: Container(
            padding: const EdgeInsets.all(AppDimens.space16),
            decoration: BoxDecoration(
              color: song.color,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(
                color: isPlaying ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
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
                  child: Icon(song.icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: AppDimens.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(song.title, style: AppTextStyles.label),
                      const SizedBox(height: AppDimens.space4),
                      Text(
                        '${controller.formatSeconds(song.durationSeconds)}'
                        ' • ${song.description}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      if (isPlaying) ...<Widget>[
                        const SizedBox(height: AppDimens.space8),
                        LinearProgressIndicator(
                          value: controller.progress.value,
                          backgroundColor: Colors.white,
                          color: AppColors.primary,
                          minHeight: 6,
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusChip),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                // Quick preview only: own tap so it does not navigate.
                GestureDetector(
                  onTap: () => controller.togglePlay(song),
                  child: _PlayButton(isPlaying: isPlaying),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Circular play/pause button on the card's end side.
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

/// White section with the three background-sound chips (one at a time).
class _BackgroundsSection extends StatelessWidget {
  const _BackgroundsSection();

  @override
  Widget build(BuildContext context) {
    final SingingController controller = Get.find<SingingController>();

    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'خلفيات من الطبيعة',
            style: AppTextStyles.label,
          ),
          const SizedBox(height: AppDimens.space12),
          Row(
            children: <Widget>[
              for (final String name in SingingController.backgrounds) ...<Widget>[
                Expanded(
                  child: Obx(
                    () => _BackgroundChip(
                      label: name,
                      isSelected: controller.selectedBackground.value == name,
                      onTap: () => controller.toggleBackground(name),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.space8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _BackgroundChip extends StatelessWidget {
  const _BackgroundChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.space8),
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

/// Big purple record button; while recording shows a red dot + timer.
class _RecordButton extends StatelessWidget {
  const _RecordButton();

  @override
  Widget build(BuildContext context) {
    final SingingController controller = Get.find<SingingController>();

    return Obx(
      () => AppButton(
        label: controller.isRecording.value
            ? 'إيقاف التسجيل • ${controller.recordingLabel}'
            : 'غنِّ وسجّل نشيدك',
        icon: controller.isRecording.value
            ? const Icon(
                Icons.fiber_manual_record_rounded,
                size: 20,
                color: Colors.white,
              )
            : const Icon(Icons.mic_rounded, size: 20),
        onPressed: controller.toggleRecording,
      ),
    );
  }
}

class _SoundToggle extends StatelessWidget {
  const _SoundToggle();

  @override
  Widget build(BuildContext context) {
    final SingingController controller = Get.find<SingingController>();

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
