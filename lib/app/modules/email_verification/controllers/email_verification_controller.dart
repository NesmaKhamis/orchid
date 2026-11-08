import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/auth_failure.dart';
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
    _startCountdown();
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
    try {
      final bool isVerified = await _repository.reloadAndCheckVerified();
      if (_closed) return;

      if (isVerified) {
        final SessionService session = Get.find<SessionService>();
        await session.markRegistrationIncomplete();
        await session.saveStep(Routes.linkIdentity);
        if (_closed) return;
        Get.offAllNamed(Routes.linkIdentity);
        return;
      }

      AppSnackbar.warning('لم يتم تأكيد البريد بعد، تحقق من صندوق الوارد');
    } on AuthFailure catch (failure) {
      Get.log(
        'Could not confirm email verification: ${failure.code ?? 'unknown'}',
      );
      AppSnackbar.error(failure.message);
    } catch (error) {
      Get.log('Could not confirm email verification: $error');
      AppSnackbar.error('تعذر التحقق من البريد الإلكتروني، حاول مجدداً');
    } finally {
      if (!_closed) {
        isLoading.value = false;
      }
    }
  }

  Future<void> resendLink() async {
    if (!canResend) return;
    try {
      await _sendVerificationLink();
      if (_closed) return;
      _startCountdown();
      AppSnackbar.info('تم إرسال رابط تأكيد جديد');
    } on AuthFailure catch (failure) {
      Get.log(
        'Could not resend email verification: ${failure.code ?? 'unknown'}',
      );
      AppSnackbar.error(failure.message);
    } catch (error) {
      Get.log('Could not resend email verification: $error');
      AppSnackbar.error('تعذر إرسال رابط التحقق، حاول مجدداً');
    }
  }

  @override
  void onClose() {
    _closed = true;
    _timer?.cancel();
    emailController.dispose();
    super.onClose();
  }
}
