import 'package:get/get.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/services/session_service.dart';
import '../../../data/models/child_model.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final ChildrenRepository _repository = Get.find<ChildrenRepository>();

  final currentChild = Rxn<ChildModel>();

  // نسبة تقدم التحدي اليومي (مثلاً 60%)
  final RxDouble challengeProgress = 0.6.obs;

  @override
  void onInit() {
    super.onInit();
    _loadChild();
  }

  Future<void> _loadChild() async {
    final arguments = Get.arguments;
    if (arguments is ChildModel) {
      currentChild.value = arguments;
      return;
    }

    try {
      final children = await _repository.getChildren();
      if (isClosed) return;

      final selectedChildId = Get.find<SessionService>().selectedChildId;
      ChildModel? selectedChild;
      for (final child in children) {
        if (child.id == selectedChildId) {
          selectedChild = child;
          break;
        }
      }

      currentChild.value =
          selectedChild ?? (children.isEmpty ? null : children.first);
    } catch (error) {
      Get.log('Could not load the current child: $error');
      AppSnackbar.error('تعذر تحميل بيانات الطفل، حاول مجدداً');
    }
  }

  // دالة عند الضغط على أحد الكاردات أو زر الإشعارات
  void onNotificationPressed() {
    // منطق الإشعارات هنا
  }

  // نقطة الدخول الحالية لتخصيص بطاقة ورشات الدعم النفسي والاجتماعي.
  void onWorkshopsPressed() {
    Get.toNamed(Routes.workshops);
  }

  // الانتقال إلى شاشة "عَبِّر عن نفسك"
  void onExpressYourselfPressed() {
    Get.toNamed(Routes.expressYourself);
  }
}
