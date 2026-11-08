import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class EmailVerificationController extends GetxController {
  late final AuthRepository _repository;

  final isLoading = false.obs;
  final secondsRemaining = AppConstants.emailVerificationResendSeconds.obs;
  final emailController = TextEditingController();

  Timer? _timer;
  bool _closed = false;

  bool get canContinue => !isLoading.value;
  bool get canResend => secondsRemaining.value == 0;

  String get countdownLabel {
    final int total = secondsRemaining.value;
    final int minutes = total ~/ 60;
    final int seconds = total % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<AuthRepository>();
    emailController.text = _repository.currentEmail;
    _sendVerificationLink();
    _startCountdown();
  }

  @override
  void onReady() {
    super.onReady();
    Get.find<SessionService>().saveStep(Routes.emailVerification);
  }

  Future<void> _sendVerificationLink() async {
    await _repository.sendEmailVerification();
  }

  void _startCountdown() {
    _timer?.cancel();
    secondsRemaining.value = AppConstants.emailVerificationResendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> confirm() async {
    if (!canContinue) return;

    isLoading.value = true;
    final bool isVerified = await _repository.reloadAndCheckVerified();
    if (_closed) return;
    isLoading.value = false;

    if (isVerified) {
      await Get.find<SessionService>().markRegistrationComplete();
      if (_closed) return;
      Get.offAllNamed(Routes.home);
      return;
    }

    AppSnackbar.warning('لم يتم تأكيد البريد بعد، تحقق من صندوق الوارد');
  }

  Future<void> resendLink() async {
    if (!canResend) return;
    await _sendVerificationLink();
    if (_closed) return;
    _startCountdown();
    AppSnackbar.info('تم إرسال رابط تأكيد جديد');
  }

  @override
  void onClose() {
    _closed = true;
    _timer?.cancel();
    emailController.dispose();
    super.onClose();
  }
}
