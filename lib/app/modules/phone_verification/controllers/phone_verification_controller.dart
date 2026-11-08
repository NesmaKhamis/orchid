import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/widgets/otp_input.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class PhoneVerificationController extends GetxController {
  late final AuthRepository _repository;

  final otp = ''.obs;
  final isLoading = false.obs;
  final secondsRemaining = AppConstants.otpResendSeconds.obs;

  final phoneController = TextEditingController();
  final otpInputController = OtpInputController();

  Timer? _timer;
  bool _closed = false;

  bool get canConfirm =>
      otp.value.length == AppConstants.otpLength && !isLoading.value;

  bool get canResend => secondsRemaining.value == 0;

  String get countdownLabel {
    final int total = secondsRemaining.value;
    final String minutes = (total ~/ 60).toString().padLeft(2, '0');
    final String seconds = (total % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    super.onInit();
    _repository = Get.find<AuthRepository>();
    _loadParentPhone();
    _startCountdown();
  }

  @override
  void onReady() {
    super.onReady();
    Get.find<SessionService>().saveStep(Routes.phoneVerification);
  }

  Future<void> _loadParentPhone() async {
    final String maskedPhone = await _repository.getParentPhoneMasked();
    if (_closed) return;
    phoneController.text = maskedPhone;
  }

  void _startCountdown() {
    _timer?.cancel();
    secondsRemaining.value = AppConstants.otpResendSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void onOtpChanged(String code) {
    otp.value = code;
  }

  Future<void> confirm() async {
    if (!canConfirm) return;

    isLoading.value = true;
    final bool isValid = await _repository.verifyOtp(otp.value);
    if (_closed) return;
    isLoading.value = false;

    if (isValid) {
      await Get.find<SessionService>().markRegistrationComplete();
      if (_closed) return;
      Get.offAllNamed(Routes.home);
      return;
    }

    AppSnackbar.error('الرمز غير صحيح، حاول مجدداً');
    otp.value = '';
    otpInputController.clear();
  }

  void resendCode() {
    if (!canResend) return;
    _startCountdown();
    AppSnackbar.info('تم إرسال رمز جديد');
  }

  @override
  void onClose() {
    _closed = true;
    _timer?.cancel();
    phoneController.dispose();
    super.onClose();
  }
}
