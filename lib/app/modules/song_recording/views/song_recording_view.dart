import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_header_bar.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/notice_banner.dart';
import '../controllers/song_recording_controller.dart';

/// Screen: lyrics + personal recording (UI preview only).
class SongRecordingView extends GetView<SongRecordingController> {
  const SongRecordingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.cream,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeader(),
          if (controller.hasSong)
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: AppDimens.screenHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const SizedBox(height: AppDimens.space8),
                      const _StatusPills(),
                      const SizedBox(height: AppDimens.space16),
                      const _LyricsCard(),
                      const SizedBox(height: AppDimens.space16),
                      const _Waveform(),
                      const SizedBox(height: AppDimens.space16),
                      const _ControlsRow(),
                      const SizedBox(height: AppDimens.space16),
                      const _BackgroundChips(),
                      const SizedBox(height: AppDimens.space16),
                      const _SavedRecordingsCard(),
                      const SizedBox(height: AppDimens.space16),
                      const _SaveButton(),
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
            )
          else
            const Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return AppHeaderBar(
      caption: '05 / الغناء والإنشاد',
      // Song is read once here — it is not an observable, no Obx needed.
      title: controller.hasSong ? controller.song.title : 'تسجيل النشيد',
      trailing: const _SoundToggle(),
      onBackPressed: Get.back,
    );
  }
}

/// "خاص" pill + recording state pill ("جاهز للتسجيل" / "تسجيل • mm:ss").
class _StatusPills extends StatelessWidget {
  const _StatusPills();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _StatusPill(
          label: 'خاص',
          icon: Icons.lock_outline_rounded,
          iconColor: AppColors.primary,
          backgroundColor: AppColors.lavender,
          labelColor: AppColors.primary,
        ),
        const SizedBox(width: AppDimens.space8),
        const Spacer(),
        const _RecordingStatePill(),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.labelColor,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space12,
        vertical: AppDimens.space4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimens.radiusChip),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: AppDimens.space4),
          Flexible(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: labelColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordingStatePill extends StatelessWidget {
  const _RecordingStatePill();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return Obx(
      () {
        final bool recording =
            controller.isRecording.value && !controller.isPaused.value;
        final Color backgroundColor = recording
            ? AppColors.softPink
            : AppColors.softMint;
        return _StatusPill(
          label: controller.statePillLabel,
          icon: Icons.fiber_manual_record_rounded,
          iconColor: recording ? AppColors.error : AppColors.textSubtitle,
          backgroundColor: backgroundColor,
          labelColor: AppColors.textDark,
        );
      },
    );
  }
}

/// Lavender swipeable lyrics card: one verse per page.
class _LyricsCard extends StatelessWidget {
  const _LyricsCard();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: AppColors.lavender,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'كلمات النشيد',
                  style: AppTextStyles.label,
                ),
              ),
              // Reads the current verse observable inside its own Obx.
              Obx(
                () => Text(
                  'مقطع ${controller.currentVerse.value + 1} '
                  'من ${controller.song.verses.length}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSubtitle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.space8),
          _VersePager(),
        ],
      ),
    );
  }
}

/// Horizontal PageView of the verses (first lines bold, rest lighter).
class _VersePager extends StatefulWidget {
  @override
  State<_VersePager> createState() => _VersePagerState();
}

class _VersePagerState extends State<_VersePager> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return SizedBox(
      height: 132,
      child: PageView.builder(
        controller: _pageController,
        itemCount: controller.song.verses.length,
        onPageChanged: controller.onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          return _VersePage(lines: controller.song.verses[index]);
        },
      ),
    );
  }
}

class _VersePage extends StatelessWidget {
  const _VersePage({required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < lines.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimens.space4),
            child: Text(
              lines[i],
              textAlign: TextAlign.center,
              style: i < 2
                  ? AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    )
                  : AppTextStyles.body.copyWith(
                      color: AppColors.textSubtitle,
                    ),
            ),
          ),
      ],
    );
  }
}

/// Animated waveform driven by a local AnimationController; the amplitude
/// gain reads the controller's reactive state inside its own Obx.
class _Waveform extends StatefulWidget {
  const _Waveform();

  @override
  State<_Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<_Waveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return AnimatedBuilder(
      animation: _waveController,
      builder: (BuildContext context, Widget? child) {
        return Obx(() {
          final bool recording = controller.isRecording.value;
          final bool paused = controller.isPaused.value;
          final double gain = recording && !paused
              ? 1.0
              : recording
                  ? 0.15
                  : 0.35;
          final Color barColor =
              recording && !paused ? AppColors.primary : AppColors.textMuted;

          final double t = _waveController.value;
          return SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                for (int i = 0; i < 24; i++)
                  Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: barColor.withValues(
                        alpha: recording ? 0.9 : 0.5,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusChip),
                    ),
                    height: 6 +
                        (math.sin(i * 1.1 + t * math.pi * 2).abs() * gain) *
                            36,
                  ),
              ],
            ),
          );
        });
      },
    );
  }
}

/// Restart / big record button / pause-resume.
class _ControlsRow extends StatelessWidget {
  const _ControlsRow();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Obx(
          () => IconButton(
            onPressed: controller.isRecording.value
                ? controller.restartRecording
                : null,
            icon: const Icon(Icons.replay_rounded),
            color: controller.isRecording.value
                ? AppColors.primary
                : AppColors.textMuted.withValues(alpha: 0.4),
          ),
        ),
        const SizedBox(width: AppDimens.space16),
        // Reads state inside its own Obx (no nested Obx sharing).
        const _RecordButtonCircle(),
        const SizedBox(width: AppDimens.space16),
        // Reads state inside its own Obx.
        const _PauseButton(),
      ],
    );
  }
}

class _RecordButtonCircle extends StatelessWidget {
  const _RecordButtonCircle();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return Obx(
      () {
        final bool recording = controller.isRecording.value;
        return GestureDetector(
          onTap: controller.toggleRecord,
          child: Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              recording
                  ? Icons.stop_rounded
                  : Icons.mic_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        );
      },
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return Obx(
      () {
        final bool canPause =
            controller.isRecording.value && !controller.isPaused.value;
        return IconButton(
          onPressed: controller.isRecording.value
              ? controller.togglePause
              : null,
          icon: Icon(
            controller.isPaused.value
                ? Icons.play_arrow_rounded
                : Icons.pause_rounded,
          ),
          color: canPause || controller.isPaused.value
              ? AppColors.primary
              : AppColors.textMuted.withValues(alpha: 0.4),
        );
      },
    );
  }
}

/// White card with المطر / العصافير / الأمواج chips.
class _BackgroundChips extends StatelessWidget {
  const _BackgroundChips();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusCard),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: <Widget>[
          for (final String name in <String>['المطر', 'العصافير', 'الأمواج'])
            ...<Widget>[
              Expanded(
                child: _BackgroundChip(
                  label: name,
                  onTap: () => controller.selectChip(name),
                ),
              ),
              if (name != 'الأمواج')
                const SizedBox(width: AppDimens.space8),
            ],
        ],
      ),
    );
  }
}

class _BackgroundChip extends StatelessWidget {
  const _BackgroundChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    // Each chip has its own Obx reading the selected chip observable.
    return Obx(
      () {
        final bool isSelected = controller.selectedChip.value == label;
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
      },
    );
  }
}

/// "تسجيلي المحفوظ" card with saved labels, or an empty state.
class _SavedRecordingsCard extends StatelessWidget {
  const _SavedRecordingsCard();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    return Obx(
      () {
        final List<String> recordings = controller.savedRecordings;
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
                'تسجيلي المحفوظ',
                style: AppTextStyles.label,
              ),
              const SizedBox(height: AppDimens.space12),
              if (recordings.isEmpty)
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.mic_none_rounded,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: AppDimens.space8),
                    Expanded(
                      child: Text(
                        'لا توجد تسجيلات بعد. سجّل نشيدك الأول!',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                )
              else
                for (final String label in recordings)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimens.space4,
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.play_circle_rounded,
                          size: 22,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppDimens.space8),
                        Expanded(
                          child: Text(
                            label,
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

    // Reads its own state inside a dedicated Obx.
    return Obx(
      () => AppButton(
        label: 'حفظ التسجيل في ملفي',
        onPressed: controller.hasUnsavedRecording.value
            ? controller.saveRecording
            : null,
      ),
    );
  }
}

class _SoundToggle extends StatelessWidget {
  const _SoundToggle();

  @override
  Widget build(BuildContext context) {
    final SongRecordingController controller =
        Get.find<SongRecordingController>();

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
