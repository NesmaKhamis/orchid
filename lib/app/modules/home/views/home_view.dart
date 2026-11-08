import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/animated_orchid.dart';
import '../../../core/widgets/hero_card_container.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const textDark = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: AppColors.coolLavender,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. الشريط العلوي (زر الإشعارات فقط بدون زر الرجوع والدائرة)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    final bool hasUnread =
                        controller.unreadNotificationsCount.value > 0;
                    return Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.notifications_outlined,
                              color: AppColors.primary,
                              size: 22,
                            ),
                            onPressed: controller.onNotificationPressed,
                          ),
                          if (hasUnread)
                            PositionedDirectional(
                              top: 10,
                              end: 10,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ),

              const SizedBox(height: 20),

              // مرحباً باسم الطفل الحقيقي
              Obx(
                () => Text(
                  'مرحباً، ${controller.currentChild.value?.name ?? ''} 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // العنوان الترحيبي العريض
              const Text(
                'أهلاً بك يا بطل في الأُوركيد! جاهز لمغامرة اليوم؟ ✨',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              // 2. بطاقة التحدي الكبرى
              HeroCardContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: const [
                        AnimatedOrchid(size: 72, autoStart: true),
                        SizedBox(width: AppDimens.space16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تحدي اليوم • 8-12 سنة',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppDimens.space4),
                              Text(
                                'اسمع، ثم اكتب كلمة',
                                style: AppTextStyles.title,
                              ),
                              SizedBox(height: AppDimens.space4),
                              Text(
                                'استمع للصوت واختر الحرف المناسب',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '6 من 10 محتويات مكتملة • التالي: G',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.space8),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusChip),
                      child: const LinearProgressIndicator(
                        value: 0.6,
                        backgroundColor: AppColors.white,
                        color: AppColors.primary,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. الكاردات الثلاثة الأفقية
              Center(
                child: Column(
                  children: [
                    _buildLargeCard(
                      title: 'ورشات الدعم النفسي والاجتماعي',
                      subtitle: 'موعدنا السبت 24 أكتوبر، 10 صباحاً',
                      icon: Icons.support_agent_rounded,
                      bgColor: const Color(0xFFE3F5E5),
                      iconColor: const Color(0xFF1B5E20),
                      onTap: controller.onWorkshopsPressed,
                    ),
                    const SizedBox(height: 16),
                    _buildLargeCard(
                      title: 'رحلتي لتعلم اللغة الإنجليزية',
                      subtitle: 'واصل المستوى ۳ - حرف G وكلمة Grape',
                      icon: Icons.menu_book_rounded,
                      bgColor: const Color(0xFFFFF4DC),
                      iconColor: const Color(0xFFB76E00),
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),
                    _buildLargeCard(
                      title: 'عَبِّر عن نفسك',
                      subtitle: 'ارسم فكرتك، لوّن لحظة، أو عبّر عن هدود',
                      icon: Icons.palette_rounded,
                      bgColor: const Color(0xFFFFE8EF),
                      iconColor: const Color(0xFFAD1457),
                      onTap: controller.onExpressYourselfPressed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }
}
