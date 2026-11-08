import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/workshop_model.dart';
import '../../../data/repositories/workshops_repository.dart';
import '../../../routes/app_routes.dart';

class WorkshopListController extends GetxController {
  WorkshopListController({required WorkshopsRepository repository})
    : _repository = repository;

  final WorkshopsRepository _repository;
  final workshops = <WorkshopModel>[].obs;
  final isLoading = true.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWorkshops();
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

  void openDetails(WorkshopModel workshop) {
    Get.toNamed(Routes.workshopDetails, arguments: workshop);
  }

  void openMyWorkshops() {
    Get.toNamed(Routes.myWorkshops);
  }

  void showLoadError() {
    AppSnackbar.error('تعذر تحميل الورشات، حاول مجدداً');
  }
}
