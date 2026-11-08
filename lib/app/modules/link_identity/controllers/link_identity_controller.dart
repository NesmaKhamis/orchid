import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/session_service.dart';
import '../../../routes/app_routes.dart';

class LinkIdentityController extends GetxController {
  final identityController = TextEditingController();
  final birthDateController = TextEditingController();

  var isLoading = false.obs;
  var selectedDate = Rxn<DateTime>();

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
      birthDateController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  // دالة البحث في قاعدة البيانات والتحقق
  void verifyAndSearchChildren() async {
    if (identityController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى إدخال رقم الهوية',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    if (birthDateController.text.trim().isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار تاريخ الميلاد للتحقق',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.amber.shade100,
        colorText: Colors.black87,
      );
      return;
    }

    isLoading.value = true;

    // محاكاة الاتصال بقاعدة البيانات (مؤقتاً)
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    // الانتقال لشاشة اختيار الأبناء (سننشئها في الخطوة القادمة)
    Get.toNamed(Routes.selectChildren);
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
