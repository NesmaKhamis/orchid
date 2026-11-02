import 'package:get/get.dart';
import 'package:orchid_app/app/modules/select_children/controllers/select_children_controller.dart';

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
        avatarAsset: 'assets/images/orchid_single.png',
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
}