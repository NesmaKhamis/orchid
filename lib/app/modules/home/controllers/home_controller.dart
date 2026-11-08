import 'dart:async';

import 'package:get/get.dart';

import '../../../core/services/session_service.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/child_model.dart';
import '../../../data/repositories/children_repository.dart';
import '../../../data/repositories/notifications_repository.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final ChildrenRepository _repository = Get.find<ChildrenRepository>();

  final Rxn<ChildModel> currentChild = Rxn<ChildModel>();

  // نسبة تقدم التحدي اليومي (مثلاً 60%)
  final RxDouble challengeProgress = 0.6.obs;

  final RxInt unreadNotificationsCount = 0.obs;
  StreamSubscription<int>? _unreadNotificationsSub;

  @override
  void onInit() {
    super.onInit();
    _loadChild();
    _subscribeToNotifications();
  }

  void _subscribeToNotifications() {
    if (Get.isRegistered<NotificationsRepository>()) {
      _unreadNotificationsSub = Get.find<NotificationsRepository>()
          .watchUnreadCount()
          .listen((int count) {
        unreadNotificationsCount.value = count;
      });
    }
  }

  Future<void> _loadChild() async {
    final dynamic arguments = Get.arguments;
    if (arguments is ChildModel) {
      currentChild.value = arguments;
      return;
    }

    try {
      final List<ChildModel> children = await _repository.getChildren();
      if (isClosed) return;

      final String? selectedChildId =
          Get.find<SessionService>().selectedChildId;
      ChildModel? selectedChild;
      for (final ChildModel child in children) {
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

  void onNotificationPressed() {
    Get.toNamed(Routes.notifications);
  }

  // نقطة الدخول الحالية لتخصيص بطاقة ورشات الدعم النفسي والاجتماعي.
  void onWorkshopsPressed() {
    Get.toNamed(Routes.workshops);
  }

  // الانتقال إلى شاشة "عَبِّر عن نفسك"
  void onExpressYourselfPressed() {
    Get.toNamed(Routes.expressYourself);
  }

  @override
  void onClose() {
    _unreadNotificationsSub?.cancel();
    super.onClose();
  }
}
