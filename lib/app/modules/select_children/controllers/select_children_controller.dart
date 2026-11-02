import 'package:get/get.dart';
import 'package:orchid_app/app/modules/child_details/controllers/child_details_controller.dart';
import 'package:orchid_app/app/modules/child_details/views/child_details_view.dart';


// نموذج بيانات الطفل
class ChildModel {
  final String id;
  final String name;
  final String grade;
  final String avatarAsset;

  ChildModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.avatarAsset,
  });
}

class SelectChildrenController extends GetxController {
  var childrenList = <ChildModel>[].obs;
  var selectedChildId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadChildrenData();
  }

  void loadChildrenData() {
    childrenList.assignAll([
      ChildModel(
        id: '1',
        name: 'محمد أحمد دياب',
        grade: 'الصف الأول الابتدائي',
        avatarAsset: 'assets/images/orchid_single.png',
      ),
      ChildModel(
        id: '2',
        name: 'مريم أحمد دياب',
        grade: 'مرحلة الروضة (KG2)',
        avatarAsset: 'assets/images/orchid_single.png',
      ),
    ]);

    if (childrenList.isNotEmpty) {
      selectedChildId.value = childrenList.first.id;
    }
  }

  void selectChild(String id) {
    selectedChildId.value = id;
  }

  // الانتقال الآمن مع تهيئة الـ Controller الخاص بتفاصيل الطفل
  void proceedToChildDetails() {
    final selectedChild = childrenList.firstWhere((c) => c.id == selectedChildId.value);
    
    Get.to(
      () => const ChildDetailsView(),
      arguments: selectedChild,
      binding: BindingsBuilder(() {
        Get.put(ChildDetailsController());
      }),
    );
  }
}