import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/child_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  ProfileController(
    this._repository,
    this._sessionService,
    this._childrenRepository,
  );

  final ProfileRepository _repository;
  final SessionService _sessionService;
  final ChildrenRepository _childrenRepository;
  final ImagePicker _imagePicker = ImagePicker();

  final profile = Rxn<ProfileModel>();
  final activeChild = Rxn<ChildModel>();
  final isLoading = false.obs;
  final isLoggingOut = false.obs;
  final isUpdatingProfile = false.obs;
  final childNameController = TextEditingController();

  static const List<String> avatarOptions = <String>[
    AppAssets.orchidSingle,
    AppAssets.orchidMascot,
    AppAssets.orchidOpen,
    AppAssets.orchidWink,
  ];

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final ProfileModel loadedProfile = await _repository.getProfile();
      try {
        final List<ChildModel> children = await _childrenRepository
            .getChildren();
        final String? selectedChildId = _sessionService.selectedChildId;
        ChildModel? child;
        for (final ChildModel candidate in children) {
          if (candidate.id == selectedChildId) {
            child = candidate;
            break;
          }
        }
        activeChild.value = child ?? (children.isEmpty ? null : children.first);
      } catch (error) {
        Get.log('Could not resolve the active child profile: $error');
      }

      final ChildModel? child = activeChild.value;
      profile.value = child == null
          ? loadedProfile
          : loadedProfile.copyWith(childName: child.name);
      childNameController.text = profile.value!.childName;
    } catch (error) {
      Get.log('Could not load profile data: $error');
      profile.value = const ProfileModel.empty();
      AppSnackbar.error('تعذر تحميل بيانات التواصل، حاول مجدداً');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateChildName(String name) async {
    final String trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      AppSnackbar.error('يرجى كتابة اسم الطفل');
      return;
    }
    await _updateProfile(
      update: () => _repository.updateChildName(trimmedName),
      profileUpdate: (current) => current.copyWith(childName: trimmedName),
      successMessage: 'تم تحديث الاسم',
    );
  }

  Future<void> updateAvatarPath(String path) async {
    await _updateProfile(
      update: () => _repository.updateAvatarPath(path),
      profileUpdate: (current) => current.copyWith(avatarPath: path),
      successMessage: 'تم تحديث الصورة',
    );
  }

  Future<String?> pickAvatarFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      return image?.path;
    } on PlatformException catch (error) {
      Get.log('Could not pick a profile image: ${error.message}');
      AppSnackbar.error('تعذر اختيار الصورة، حاول مجدداً');
      return null;
    }
  }

  Future<void> _updateProfile({
    required Future<void> Function() update,
    required ProfileModel Function(ProfileModel current) profileUpdate,
    required String successMessage,
  }) async {
    if (isUpdatingProfile.value) return;
    isUpdatingProfile.value = true;
    try {
      await update();
      final ProfileModel current = profile.value ?? const ProfileModel.empty();
      profile.value = profileUpdate(current);
      childNameController.text = profile.value!.childName;
      AppSnackbar.success(successMessage);
    } catch (error) {
      Get.log('Could not update child profile: $error');
      AppSnackbar.error('تعذر تحديث الملف الشخصي، حاول مجدداً');
    } finally {
      isUpdatingProfile.value = false;
    }
  }

  Future<void> shareApp() async {
    try {
      await Clipboard.setData(
        const ClipboardData(text: 'اكتشفوا تطبيق أوركيد لمشاعر الأطفال!'),
      );
      AppSnackbar.success('تم نسخ رسالة المشاركة');
    } catch (error) {
      Get.log('Could not copy the app share message: $error');
      AppSnackbar.error('تعذرت مشاركة التطبيق، حاول مجدداً');
    }
  }

  void submitRating(int rating) {
    if (rating < 1 || rating > 5) {
      AppSnackbar.error('اختر تقييماً من نجمة إلى خمس نجوم');
      return;
    }
    AppSnackbar.success('شكراً لتقييمك للتطبيق');
  }

  void onChangeLanguage() {
    AppSnackbar.info('التطبيق متاح باللغة العربية حالياً');
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;
    try {
      await _sessionService.logout();
      await Get.offAllNamed<void>(Routes.login);
    } catch (error) {
      Get.log('Could not complete logout navigation: $error');
      AppSnackbar.error('تعذر تسجيل الخروج، حاول مجدداً');
    } finally {
      isLoggingOut.value = false;
    }
  }

  @override
  void onClose() {
    childNameController.dispose();
    super.onClose();
  }
}
