import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/session_service.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  // --- حقول تسجيل الدخول ---
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // --- حقول إضافية لإنشاء الحساب ---
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // --- حالات رؤية كلمة المرور ---
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // --- حالة التحميل ---
  var isLoading = false.obs;

  // دالة إظهار/إخفاء كلمة المرور الرئيسية
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // دالة إظهار/إخفاء تأكيد كلمة المرور
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // دالة تسجيل الدخول
  Future<void> login() async {
    isLoading.value = true;

    // Login is still fake; Firebase will provide account state from the real user profile.
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    final session = Get.find<SessionService>();
    await session.markLoggedIn();
    Get.offAllNamed(session.resolveStartRoute());
  }

  // دالة إنشاء الحساب
  Future<void> register() async {
    isLoading.value = true;

    // TODO: replace with Firebase Auth
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    final session = Get.find<SessionService>();
    await session.markLoggedIn();
    await session.markRegistrationIncomplete();
    await session.saveStep(Routes.linkIdentity);

    // الانتقال لشاشة ربط الهوية بعد إنشاء الحساب
    Get.offAllNamed(Routes.linkIdentity);
  }

  // الانتقال إلى صفحة إنشاء الحساب
  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  // العودة إلى صفحة تسجيل الدخول
  void goToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
