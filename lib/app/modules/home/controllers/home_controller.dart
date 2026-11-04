import 'package:get/get.dart';
import 'package:orchid_app/app/data/models/child_model.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  // استقبال بيانات الطفل المُمررة بأمان تام مع قيمة افتراضية احتياطية
  late final ChildModel currentChild;

  // نسبة تقدم التحدي اليومي (مثلاً 60%)
  final RxDouble challengeProgress = 0.6.obs;

  @override
  void onInit() {
    super.onInit();
    
    // التحقق من وجود arguments لمنع حدوث خطأ Unexpected null value
    if (Get.arguments != null && Get.arguments is ChildModel) {
      currentChild = Get.arguments;
    } else {
      currentChild = ChildModel(
        id: '1',
        name: 'محمد أحمد دياب',
        grade: 'الصف الأول الابتدائي',
        avatarAsset: 'assets/images/orchid_single.png', nationalId: '', birthDate: DateTime(2017, 9, 7, 17, 30)
      );
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // دالة عند الضغط على أحد الكاردات أو زر الإشعارات
  void onNotificationPressed() {
    // منطق الإشعارات هنا
  }

  // الانتقال إلى شاشة "عَبِّر عن نفسك"
  void onExpressYourselfPressed() {
    Get.toNamed(Routes.expressYourself);
  }
}