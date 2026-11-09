import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_entrance.dart';
import '../../../core/widgets/animated_orchid.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/feeling_card.dart';
import '../../../core/widgets/notice_banner.dart';
import '../../../data/models/feeling.dart';
import '../controllers/feelings_controller.dart';

class FeelingsView extends GetView<FeelingsController> {
  const FeelingsView({super.key});

  static const List<Color> _pastelPalette = <Color>[
    AppColors.softYellow,
    AppColors.softBlue,
    AppColors.lavender,
    AppColors.softPink,
    AppColors.softMint,
    AppColors.coolLavender,
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: AppScaffoldBackground.coolLavender,
      scrollable: true,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.screenHorizontalPadding,
        vertical: AppDimens.space12,
      ),
      body: Obx(() {
        if (controller.isSubmitted.value) {
          return _buildResultStep();
        }
        return _buildCheckInStep(context);
      }),
    );
  }

  Widget _buildCheckInStep(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Top row with back button
        Row(
          children: <Widget>[
            AppBackButton(onPressed: controller.finish),
          ],
        ),

        const SizedBox(height: AppDimens.space8),

        // Animated orchid mascot
        const Center(
          child: AnimatedOrchid(size: 88),
        ),

        const SizedBox(height: AppDimens.space12),

        // Title
        const Text(
          'كيف قلبك اليوم؟',
          textAlign: TextAlign.center,
          style: AppTextStyles.h2,
        ),

        const SizedBox(height: AppDimens.space4),

        // Subtitle
        Text(
          'كل المشاعر مقبولة',
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            color: AppColors.textSubtitle,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: AppDimens.space16),

        if (controller.errorMessage.value.isNotEmpty) ...<Widget>[
          NoticeBanner(
            tone: NoticeBannerTone.danger,
            text: controller.errorMessage.value,
          ),
          const SizedBox(height: AppDimens.space12),
        ],

        // 2x3 Grid of feeling cards
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: Feeling.values.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisExtent: 110.0 *
                MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.4),
            mainAxisSpacing: AppDimens.space12,
            crossAxisSpacing: AppDimens.space12,
          ),
          itemBuilder: (BuildContext context, int index) {
            final Feeling feeling = Feeling.values[index];
            final bool isSelected =
                controller.selectedFeeling.value == feeling;
            final Color pastelColor =
                _pastelPalette[index % _pastelPalette.length];

            return FeelingCard(
              feeling: feeling,
              isSelected: isSelected,
              backgroundColor: pastelColor,
              onTap: () => controller.selectFeeling(feeling),
            ).animatedEntrance(
              delay: Duration(milliseconds: index * 60),
            );
          },
        ),

        const SizedBox(height: AppDimens.space20),

        // Submit button
        AppButton(
          label: 'تابع',
          isLoading: controller.isLoading.value,
          onPressed: controller.selectedFeeling.value == null
              ? null
              : controller.submit,
        ),

        const SizedBox(height: AppDimens.space16),
      ],
    );
  }

  Widget _buildResultStep() {
    final Feeling? feeling = controller.selectedFeeling.value;
    final int coins = controller.coinsAwarded.value;
    final CalmingSuggestion? suggestion = controller.calmingSuggestion.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: AppDimens.space16),

        // Mascot
        const Center(
          child: AnimatedOrchid(size: 110),
        ),

        const SizedBox(height: AppDimens.space16),

        // Selected feeling preview
        if (feeling != null)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.space20,
                vertical: AppDimens.space12,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    feeling.emoji,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(width: AppDimens.space8),
                  Text(
                    feeling.label,
                    style: AppTextStyles.cardTitle.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 250.ms).scale(curve: Curves.easeOutBack),

        const SizedBox(height: AppDimens.space16),

        // Supportive message card
        Container(
          padding: const EdgeInsets.all(AppDimens.space16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.radiusCard),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            controller.supportiveMessage.value,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
        ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

        // Coin celebration badge if coins awarded
        if (coins > 0) ...<Widget>[
          const SizedBox(height: AppDimens.space16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.space16,
                vertical: AppDimens.space8,
              ),
              decoration: BoxDecoration(
                color: AppColors.softYellow,
                borderRadius: BorderRadius.circular(AppDimens.radiusPill),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('🪙', style: TextStyle(fontSize: 20)),
                  const SizedBox(width: AppDimens.space8),
                  Text(
                    '+$coins عملة لتسجيل مشاعرك اليوم!',
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .scale(duration: 400.ms, delay: 200.ms, curve: Curves.easeOutBack)
              .fadeIn(duration: 300.ms),
        ],

        // Calming suggestion if applicable
        if (suggestion != null) ...<Widget>[
          const SizedBox(height: AppDimens.space16),
          Container(
            padding: const EdgeInsets.all(AppDimens.space16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimens.radiusCard),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  suggestion.message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: AppDimens.space12),
                AppButton(
                  label: suggestion.buttonLabel,
                  variant: AppButtonVariant.soft,
                  onPressed: () =>
                      controller.goToCalmingActivity(suggestion.route),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms, delay: 250.ms),
        ],

        const SizedBox(height: AppDimens.space24),

        // Done button
        AppButton(
          label: 'تم',
          variant: AppButtonVariant.primary,
          onPressed: controller.finish,
        ),

        const SizedBox(height: AppDimens.space16),
      ],
    );
  }
}
