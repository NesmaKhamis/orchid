import '../../core/constants/app_assets.dart';
import '../models/child_model.dart';
import 'child_repository.dart';

class MockChildRepository implements ChildRepository {
  @override
  Future<List<ChildModel>> getChildren() async {
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      ChildModel(
        id: '1',
        name: 'محمد أحمد دياب',
        grade: 'الصف الأول الابتدائي',
        avatarAsset: AppAssets.orchidSingle,
        nationalId: '4028392011',
        birthDate: DateTime(2018, 5, 14),
      ),
      ChildModel(
        id: '2',
        name: 'مريم أحمد دياب',
        grade: 'مرحلة الروضة (KG2)',
        avatarAsset: AppAssets.orchidSingle,
        nationalId: '4028392029',
        birthDate: DateTime(2020, 9, 3),
      ),
      ChildModel(
        id: '3',
        name: 'يوسف أحمد دياب',
        grade: 'الصف السابع',
        avatarAsset: AppAssets.orchidSingle,
        nationalId: '4028392037',
        birthDate: DateTime(
          DateTime.now().year - 13,
          DateTime.now().month,
          DateTime.now().day,
        ),
      ),
    ];
  }
}
