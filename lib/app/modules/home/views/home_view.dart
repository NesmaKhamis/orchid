import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF7B3FE4);
    const textDark = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FC),
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.notifications_active_rounded, color: primaryPurple, size: 22),
                      onPressed: () => controller.onNotificationPressed(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // مرحباً باسم الطفل الحقيقي
              Text(
                'مرحباً، ${controller.currentChild.name} 👋',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEDE3F8), Color(0xFFF7F2FC)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'تحدي اليوم • 8-12 سنة',
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'اسمع، ثم اكتب كلمة',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'استمع للصوت واختر الحرف المناسب',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: 14),
                          LinearProgressIndicator(
                            value: 0.6,
                            backgroundColor: Colors.white,
                            color: primaryPurple,
                            minHeight: 8,
                          ),
                          SizedBox(height: 8),
                          Text(
                            '6 من 10 محتويات مكتملة • التالي: G',
                            style: TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/orchid_single.png', 
                            fit: BoxFit.cover,
                          ),
                        ),
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
                      onTap: () {},
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
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),

      // شريط التنقل السفلي العصري العائم
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_rounded, 'الرئيسية', true, primaryPurple),
            _buildNavItem(Icons.card_giftcard_rounded, 'الهدايا', false, primaryPurple),
            _buildNavItem(Icons.emoji_events_rounded, 'الإنجازات', false, primaryPurple),
            GestureDetector(
              onTap: () => Get.toNamed(Routes.profile),
              child: _buildNavItem(
                Icons.person_rounded,
                'الملف',
                false,
                primaryPurple,
              ),
            ),
          ],
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
              color: Colors.black.withOpacity(0.03),
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
                    color: Colors.black.withOpacity(0.04),
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
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, Color activeColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withOpacity(0.12) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected ? activeColor : Colors.grey.shade400,
            size: 24,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? activeColor : Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
