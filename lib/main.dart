import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/bindings/initial_binding.dart';
import 'app/core/services/session_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  InitialBinding().dependencies();
  await Get.find<SessionService>().init();

  // Firebase init goes here later
  runApp(const OrchidApp());
}

class OrchidApp extends StatelessWidget {
  const OrchidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'الأوركيد - Orchid',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      fallbackLocale: const Locale('ar', 'SA'),
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
