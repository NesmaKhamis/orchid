import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/workshop_model.dart';
import '../../../data/repositories/workshops_repository.dart';
import '../../../routes/app_routes.dart';

class WorkshopListController extends GetxController {
  WorkshopListController({required WorkshopsRepository repository})
    : _repository = repository;

  final WorkshopsRepository _repository;

  final selectedTab = 0.obs;

  final workshops = <WorkshopModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;

  final bookedWorkshops = <WorkshopModel>[].obs;
  final isBookedLoading = true.obs;
  final hasBookedError = false.obs;
  final cancellingWorkshopId = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadWorkshops();
    loadBookedWorkshops();
  }

  void selectTab(int index) {
    selectedTab.value = index;
    if (index == 1 && bookedWorkshops.isEmpty && !isBookedLoading.value) {
      loadBookedWorkshops();
    }
  }

  Future<void> loadWorkshops() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      workshops.assignAll(await _repository.getWorkshops());
    } catch (error) {
      Get.log('Could not load workshops: $error');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadBookedWorkshops() async {
    isBookedLoading.value = true;
    hasBookedError.value = false;
    try {
      bookedWorkshops.assignAll(await _repository.getBookedWorkshops());
    } catch (error) {
      Get.log('Could not load booked workshops: $error');
      hasBookedError.value = true;
    } finally {
      isBookedLoading.value = false;
    }
  }

  Future<void> cancelBooking(WorkshopModel workshop) async {
    if (cancellingWorkshopId.value != null) {
      return;
    }

    cancellingWorkshopId.value = workshop.id;
    try {
      await _repository.cancelBooking(workshopId: workshop.id);
      bookedWorkshops.removeWhere((item) => item.id == workshop.id);
      AppSnackbar.success('تم إلغاء حجز ${workshop.title}');
    } catch (error) {
      Get.log('Could not cancel workshop booking: $error');
      AppSnackbar.error('تعذر إلغاء الحجز، حاول مجدداً');
    } finally {
      cancellingWorkshopId.value = null;
    }
  }

  Future<void> openDetails(WorkshopModel workshop) async {
    final dynamic result =
        await Get.toNamed(Routes.workshopDetails, arguments: workshop);
    if (result == true) {
      selectedTab.value = 1;
      await loadBookedWorkshops();
    }
  }

  void openMyWorkshops() {
    selectedTab.value = 1;
  }

  void showLoadError() {
    AppSnackbar.error('تعذر تحميل الورشات، حاول مجدداً');
  }
}
