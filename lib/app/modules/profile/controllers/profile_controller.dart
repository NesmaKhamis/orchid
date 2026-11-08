import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  ProfileController(this._repository);

  final ProfileRepository _repository;

  final profile = Rxn<ProfileModel>();
  final isLoading = false.obs;
  final isLoggingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      profile.value = await _repository.getProfile();
    } catch (error) {
      Get.log('Could not load profile; trying fallback data: $error');
      try {
        profile.value = await _repository.getFallbackProfile();
        AppSnackbar.warning('نعرض بيانات الملف الشخصي المحفوظة مؤقتاً');
      } catch (fallbackError) {
        Get.log('Could not load fallback profile data: $fallbackError');
        AppSnackbar.error('تعذر تحميل بيانات الملف الشخصي، حاول مجدداً');
      }
    } finally {
      isLoading.value = false;
    }
  }

  void onChangePassword() {
    AppSnackbar.info('سيتمكن ولي الأمر من تغيير كلمة المرور قريباً');
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;
    try {
      await Get.offAllNamed<void>(Routes.login);
    } catch (error) {
      Get.log('Could not complete logout navigation: $error');
      AppSnackbar.error('تعذر تسجيل الخروج، حاول مجدداً');
    } finally {
      isLoggingOut.value = false;
    }
  }
}
