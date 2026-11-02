import 'package:get/get.dart';
import 'package:orchid_app/app/modules/select_children/controllers/select_children_controller.dart';
import 'package:orchid_app/app/routes/app_routes.dart';

class ChildDetailsController extends GetxController {
  // استخدام قيمة افتراضية مباشرة لمنع أي خطأ null نهائياً
  late ChildModel selectedChild;
  
  final String childNationalId = '4028392011';
  final String birthDate = '2018-05-14';
  
  String get calculatedAge {
    try {
      DateTime birth = DateTime.parse(birthDate);
      DateTime today = DateTime.now();
      int age = today.year - birth.year;
      if (today.month < birth.month || (today.month == birth.month && today.day < birth.day)) {
        age--;
      }
      return '$age سنوات';
    } catch (e) {
      return '6 سنوات';
    }
  }

  @override
  void onInit() {
    super.onInit();
    // التحقق الآمن جداً من الـ arguments
    if (Get.arguments != null && Get.arguments is ChildModel) {
      selectedChild = Get.arguments;
    } else {
      selectedChild = ChildModel(
        id: '1',
        name: 'محمد أحمد دياب',
        grade: 'الصف الأول الابتدائي',
        avatarAsset: 'assets/images/orchid_single.png',
      );
    }
  }

 void proceedToDashboard() {
  // الانتقال للرئيسية مع تمرير بيانات الطفل الحالي كـ arguments
  Get.offAllNamed(Routes.HOME, arguments: selectedChild);
}
}