import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 1. استيراد شاشة وعامل التحكم الموحد للحسابات (Auth)
import 'app/modules/auth/views/login_view.dart';
import 'app/modules/auth/views/register_view.dart';
import 'app/modules/auth/controllers/auth_controller.dart';

// 2. استيراد شاشة وعامل التحكم لربط الهوية (Link Identity)
import 'app/modules/link_identity/views/link_identity_view.dart';
import 'app/modules/link_identity/controllers/link_identity_controller.dart';

// 3. استيراد شاشة وعامل التحكم لاختيار الأطفال (Select Children)
import 'app/modules/select_children/views/select_children_view.dart';
import 'app/modules/select_children/controllers/select_children_controller.dart';

import 'app/core/theme/app_theme.dart';

void main() {
  runApp(const OrchidApp());
}

class OrchidApp extends StatelessWidget {
  const OrchidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'الأوركيد - Orchid',
      debugShowCheckedModeBanner: false,
      
      // الضبط الافتراضي للغة واتجاه التطبيق (من اليمين لليسار)
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),

      // الثيم العام للتطبيق
      theme: AppTheme.light,

      // الشاشة الأولى التي يبدأ منها التطبيق (يمكنكِ تغييرها إلى '/register' أو '/link-identity' للاختبار المباشر)
      initialRoute: '/login',

      // خريطة المسارات الكاملة للواجهات
      getPages: [
        // شاشة تسجيل الدخول
        GetPage(
          name: '/login',
          page: () => const LoginView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AuthController>(() => AuthController());
          }),
        ),

        // شاشة إنشاء الحساب
        GetPage(
          name: '/register',
          page: () => const RegisterView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<AuthController>(() => AuthController());
          }),
        ),

        // شاشة ربط الهوية والتحقق
        GetPage(
          name: '/link-identity',
          page: () => const LinkIdentityView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<LinkIdentityController>(() => LinkIdentityController());
          }),
        ),

        // شاشة اختيار الأبناء
        GetPage(
          name: '/select-children',
          page: () => const SelectChildrenView(),
          binding: BindingsBuilder(() {
            Get.lazyPut<SelectChildrenController>(() => SelectChildrenController());
          }),
        ),
      ],
    );
  }
}
