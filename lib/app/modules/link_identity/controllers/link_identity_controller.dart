import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';

class LinkIdentityController extends GetxController {
  final identityController = TextEditingController();
  final birthDateController = TextEditingController();

  final identityError = ''.obs;
  final birthDateError = ''.obs;
  final isLoading = false.obs;
  final selectedDate = Rxn<DateTime>();

  void onIdentityChanged(String value) {
    identityError.value = Validators.nationalId(value) ?? '';
  }

  // دالة فتح التقويم لاختيار تاريخ الميلاد
  Future<void> pickBirthDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B53A8), // لون الأوركيد البنفسجي
              onPrimary: Colors.white,
              onSurface: Color(0xFF2D2D2D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
      birthDateError.value = '';
      birthDateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // دالة البحث في قاعدة البيانات والتحقق
  Future<void> verifyAndSearchChildren() async {
    final String? identityValidationError = Validators.nationalId(
      identityController.text,
    );
    if (identityValidationError != null) {
      identityError.value = identityValidationError;
      return;
    }

    if (birthDateController.text.trim().isEmpty) {
      birthDateError.value = 'يرجى اختيار تاريخ الميلاد للتحقق';
      return;
    }

    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      await Get.find<SessionService>().saveStep(Routes.selectChildren);
      Get.toNamed(Routes.selectChildren);
    } catch (error) {
      Get.log('Could not complete parent verification: $error');
      AppSnackbar.error('تعذر إكمال التحقق، حاول مجدداً');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onReady() {
    super.onReady();
    Get.find<SessionService>().saveStep(Routes.linkIdentity);
  }

  @override
  void onClose() {
    identityController.dispose();
    birthDateController.dispose();
    super.onClose();
  }
}
