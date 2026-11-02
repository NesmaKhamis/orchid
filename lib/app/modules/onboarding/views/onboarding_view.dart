import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    // الألوان الرئيسية للتطبيق
    const primaryPurple = Color(0xFF8B53A8);
    const textDark = Color(0xFF2D2D2D);
    const textSubtitle = Color(0xFF6B588C);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 🌿 1. لمسة أغصان/أوراق خضراء في الزاوية العلوية اليسرى
          Positioned(
            top: -15,
            left: -15,
            child: Opacity(
              opacity: 0.85,
              child: Image.asset(
                'assets/images/leaf_top.png', // غير المسار لصورة الأوراق لديك
                width: 130,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // شكل تعويضي ناعم في حال عدم وجود الملف بعد
                  return Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.green.shade100.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(80),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideX(begin: -0.2, end: 0.0),

          // 🌿 2. لمسة أغصان/أوراق خضراء في الزاوية السفلى اليمنى
          Positioned(
            bottom: -15,
            right: -15,
            child: Opacity(
              opacity: 0.85,
              child: Transform.rotate(
                angle: 3.14159, // تدوير الصورة لتبدو مناسبة للزاوية السفلية
                child: Image.asset(
                  'assets/images/leaf_top.png', // يمكن إعادة استخدام نفس الصورة أو 'leaf_bottom.png'
                  width: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(90),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 800.ms)
              .slideX(begin: 0.2, end: 0.0),

          // 🌸 3. محتوى الواجهة الأساسي المنسق في المنتصف
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    // باقة الأوركيد الخضراء والجميلة
                    Image.asset(
                      'assets/images/orchid_mascot.png',
                      height: 210,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.filter_vintage,
                          size: 130,
                          color: primaryPurple,
                        );
                      },
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .scale(begin: const Offset(0.85, 0.85)),

                    const SizedBox(height: 30),

                    // العنوان الرئيسي
                    const Text(
                      'أهلاً بكم في عالم الأوركيد',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        height: 1.25,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0.0),

                    const SizedBox(height: 16),

                    // النص الفرعي
                    const Text(
                      'هنا، نكبر على مهل.\nنتعلّم، نعبر، ونكتشف أنفسنا...\nخطوة لطيفة كل يوم.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: textSubtitle,
                        fontWeight: FontWeight.w500,
                        height: 1.6,
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 400.ms, duration: 600.ms)
                        .slideY(begin: 0.2, end: 0.0),

                    const SizedBox(height: 40),

                    // زر "لنبدأ الرحلة"
                    SizedBox(
                      width: Get.width * 0.72,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => controller.startJourney(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          elevation: 4,
                          shadowColor: primaryPurple.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'لنبدأ الرحلة',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .scale(begin: const Offset(0.9, 0.9)),

                    const SizedBox(height: 20),
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