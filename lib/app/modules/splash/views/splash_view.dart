import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../../../routes/app_routes.dart'; // تأكد أن هذا المسار صحيح ليصل إلى Routes.ONBOARDING

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashContent();
  }
}

class SplashContent extends StatefulWidget {
  const SplashContent({super.key});

  @override
  State<SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<SplashContent> {
  bool isWinking = false;
  Timer? _winkTimer;
  Timer? _navigationTimer; // مؤقت الانتقال لشاشة الـ Onboarding

  @override
  void initState() {
    super.initState();
    _startWinkAnimation();
    _startNavigationTimer(); // تشغيل مؤقت الانتقال التلقائي
  }

  void _startWinkAnimation() {
    _winkTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (!mounted) return;
      setState(() {
        isWinking = true;
      });

      await Future.delayed(const Duration(milliseconds: 350));

      if (!mounted) return;
      setState(() {
        isWinking = false;
      });
    });
  }

  // دالة الانتقال التلقائي بعد 3 ثوانٍ
  void _startNavigationTimer() {
    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      // الانتقال لشاشة الـ Onboarding واستبدال شاشة السبلاش نهائياً
      Get.offNamed(Routes.ONBOARDING);
    });
  }

  @override
  void dispose() {
    _winkTimer?.cancel();
    _navigationTimer?.cancel(); // إلغاء التايمر لمنع تسريب الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية المتدرجة
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFD8F3DC),
                  Color(0xFFE8E8F4),
                  Color(0xFFFFF0F5),
                ],
              ),
            ),
          ),

          // هالة ضوئية نابضة
          Center(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(
                  duration: 2500.ms,
                  begin: const Offset(0.85, 0.85),
                  end: const Offset(1.1, 1.1),
                ),
          ),

          // المحتوى في المنتصف
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),

                SizedBox(
                  height: 240,
                  width: 240,
                  child: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 140),
                    crossFadeState: isWinking
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Image.asset('assets/images/orchid_open.png'),
                    secondChild: Image.asset('assets/images/orchid_wink.png'),
                  ),
                )
                    .animate(onPlay: (controller) => controller.repeat(reverse: true))
                    .shake(
                      duration: 3000.ms,
                      hz: 0.5,
                      offset: const Offset(0, 8),
                    )
                    .rotate(
                      duration: 4000.ms,
                      begin: -0.02,
                      end: 0.02,
                    ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Orchid',
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D1B4E),
                      letterSpacing: 1.5,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 600.ms)
                    .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),

                const SizedBox(height: 12),

                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF8A4FFF),
                    fontWeight: FontWeight.w700,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}