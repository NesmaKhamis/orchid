import '../models/workshop_model.dart';

abstract class WorkshopsRepository {
  Future<List<WorkshopModel>> getWorkshops();

  Future<void> bookWorkshop({required String workshopId});

  Future<List<WorkshopModel>> getBookedWorkshops();

  Future<bool> isWorkshopBooked({required String workshopId});

  Future<void> cancelBooking({required String workshopId});
}
