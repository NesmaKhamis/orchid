import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  void login() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // الانتقال لشاشة ربط الهوية بعد الدخول
    Get.offAllNamed(Routes.linkIdentity);
  }

  // دالة إنشاء الحساب
  void register() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

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
