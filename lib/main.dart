import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orchid_app/app/routes/app_routes.dart';
import 'app/routes/app_pages.dart'; // استيراد صفحة المسارات المركزية

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
      theme: ThemeData(
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B53A8),
          primary: const Color(0xFF8B53A8),
        ),
      ),

      // جعل واجهة الهوم هي البداية مباشرة للاختبار
      initialRoute: Routes.HOME,

      // استخدام قائمة المسارات المركزية من app_pages.dart لتجنب أي نقص
      getPages: AppPages.routes,
    );
  }
}