import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/bindings/initial_binding.dart';
import 'app/core/services/session_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeFirebase();

  InitialBinding().dependencies();
  await Get.find<SessionService>().init();

  runApp(const OrchidApp());
}

/// Initializes Firebase before anything else touches the app.
///
/// Platforms without a FlutterFire configuration (web, iOS, macOS, Windows, Linux)
/// make [DefaultFirebaseOptions.currentPlatform] throw [UnsupportedError]. In that
/// case the app keeps running in local mode instead of crashing, so the non-Android
/// targets stay usable while Firebase is rolled out Android-first.
Future<void> _initializeFirebase() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on UnsupportedError catch (error) {
    debugPrint(
      'Firebase is not configured for this platform, running in local mode: $error',
    );
  } catch (error, stackTrace) {
    debugPrint('Firebase initialization failed, running in local mode: $error');
    debugPrintStack(stackTrace: stackTrace);
  }
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
