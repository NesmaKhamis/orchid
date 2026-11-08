import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/workshop_model.dart';
import '../../../data/repositories/workshops_repository.dart';
import '../../../routes/app_routes.dart';

class MyWorkshopsController extends GetxController {
  MyWorkshopsController({required WorkshopsRepository repository})
    : _repository = repository;

  final WorkshopsRepository _repository;
  final workshops = <WorkshopModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;
  final cancellingWorkshopId = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadBookedWorkshops();
  }

  Future<void> loadBookedWorkshops() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      workshops.assignAll(await _repository.getBookedWorkshops());
    } catch (error) {
      Get.log('Could not load booked workshops: $error');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void openDetails(WorkshopModel workshop) {
    Get.toNamed(Routes.workshopDetails, arguments: workshop);
  }

  Future<void> cancelBooking(WorkshopModel workshop) async {
    if (cancellingWorkshopId.value != null) {
      return;
    }

    cancellingWorkshopId.value = workshop.id;
    try {
      await _repository.cancelBooking(workshopId: workshop.id);
      workshops.removeWhere((item) => item.id == workshop.id);
      AppSnackbar.success('تم إلغاء حجز ${workshop.title}');
    } catch (error) {
      Get.log('Could not cancel workshop booking: $error');
      AppSnackbar.error('تعذر إلغاء الحجز، حاول مجدداً');
    } finally {
      cancellingWorkshopId.value = null;
    }
  }
}
