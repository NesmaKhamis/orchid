import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../data/models/workshop_model.dart';
import '../../../data/repositories/workshops_repository.dart';

class WorkshopDetailsController extends GetxController {
  WorkshopDetailsController({
    required WorkshopsRepository repository,
    required this.workshop,
  }) : _repository = repository;

  final WorkshopsRepository _repository;
  final WorkshopModel workshop;
  final hasConsent = false.obs;
  final isBooking = false.obs;
  final isBooked = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBookingState();
  }

  Future<void> _loadBookingState() async {
    isBooked.value = await _repository.isWorkshopBooked(
      workshopId: workshop.id,
    );
  }

  void setConsent(bool value) {
    hasConsent.value = value;
  }

  Future<bool> bookWorkshop() async {
    if (isBooked.value) {
      return false;
    }
    if (!hasConsent.value) {
      AppSnackbar.warning('يرجى تأكيد حضور ولي الأمر أولاً');
      return false;
    }

    isBooking.value = true;
    try {
      await _repository.bookWorkshop(workshopId: workshop.id);
      isBooked.value = true;
      return true;
    } catch (error) {
      Get.log('Could not book workshop: $error');
      AppSnackbar.error('تعذر تأكيد الحجز، حاول مجدداً');
      return false;
    } finally {
      isBooking.value = false;
    }
  }
}
