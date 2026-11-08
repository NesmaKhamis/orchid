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
      await _repository.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        name: nameController.text.trim(),
      );
      await _continueAfterRegister();
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
    await session.markLoggedIn();

    isLoading.value = false;
    Get.offAllNamed(session.resolveStartRoute());
  }

  /// A new account always starts the registration details from the beginning.
  Future<void> _continueAfterRegister() async {
    final SessionService session = Get.find<SessionService>();
    await session.markLoggedIn();
    await session.markRegistrationIncomplete();
    await session.saveStep(Routes.linkIdentity);

    isLoading.value = false;
    Get.offAllNamed(Routes.linkIdentity);
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