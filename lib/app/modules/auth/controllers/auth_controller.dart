import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/auth_failure.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  late final AuthRepository _repository;

  // Login fields.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Registration-only fields.
  final nameController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<AuthRepository>();
    final Object? initialEmail = Get.arguments;
    if (Get.currentRoute == Routes.login && initialEmail is String) {
      emailController.text = initialEmail;
    }
  }

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  Future<void> login() async {
    if (isLoading.value) return;

    final String? validationError = _validateLogin();
    if (validationError != null) {
      AppSnackbar.error(validationError);
      return;
    }

    isLoading.value = true;
    try {
      await _repository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      if (!await _repository.reloadAndCheckVerified()) {
        await _repository.sendEmailVerification();
        await _continueToEmailVerification();
        AppSnackbar.info('يرجى تأكيد بريدك الإلكتروني للمتابعة');
        return;
      }
      await _continueAfterLogin();
    } on AuthFailure catch (failure) {
      Get.log('Authentication failed: ${failure.code ?? 'unknown'}');
      AppSnackbar.error(failure.message);
    } catch (_) {
      Get.log('Authentication failed with an unexpected error');
      AppSnackbar.error(AppStrings.genericError);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (isLoading.value) return;

    final String? validationError = _validateRegister();
    if (validationError != null) {
      AppSnackbar.error(validationError);
      return;
    }

    isLoading.value = true;
    try {
      final String email = emailController.text.trim();
      await _repository.signUp(
        email: email,
        password: passwordController.text,
        name: nameController.text.trim(),
      );
      final SessionService session = Get.find<SessionService>();
      await session.markRegistrationIncomplete();
      await session.saveStep(Routes.emailVerification);

      String? verificationError;
      try {
        await _repository.sendEmailVerification();
      } on AuthFailure catch (failure) {
        Get.log(
          'Could not send verification email: ${failure.code ?? 'unknown'}',
        );
        verificationError = failure.message;
      } catch (error) {
        Get.log('Could not send verification email: $error');
        verificationError = AppStrings.genericError;
      }

      isLoading.value = false;
      Get.offAllNamed(Routes.login, arguments: email);
      AppSnackbar.success('تم إنشاء الحساب بنجاح');
      if (verificationError != null) {
        AppSnackbar.warning(verificationError);
      }
    } on AuthFailure catch (failure) {
      Get.log('Registration failed: ${failure.code ?? 'unknown'}');
      AppSnackbar.error(failure.message);
    } catch (_) {
      Get.log('Registration failed with an unexpected error');
      AppSnackbar.error(AppStrings.genericError);
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.register);
  }

  void goToLogin() {
    Get.back();
  }

  /// A returning user resumes where they stopped, or goes straight to home
  /// when the registration was already completed.
  Future<void> _continueAfterLogin() async {
    final SessionService session = Get.find<SessionService>();
    isLoading.value = false;
    Get.offAllNamed(await session.resolveStartRoute());
  }

  Future<void> _continueToEmailVerification() async {
    final SessionService session = Get.find<SessionService>();
    await session.markRegistrationIncomplete();
    await session.saveStep(Routes.emailVerification);
    isLoading.value = false;
    Get.offAllNamed(Routes.emailVerification);
  }

  String? _validateLogin() {
    return Validators.email(emailController.text) ??
        Validators.passwordMin6(passwordController.text);
  }

  String? _validateRegister() {
    return Validators.required(nameController.text) ??
        Validators.email(emailController.text) ??
        Validators.passwordMin6(passwordController.text) ??
        Validators.match(
          confirmPasswordController.text,
          passwordController.text,
        );
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
