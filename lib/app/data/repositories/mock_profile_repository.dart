import '../models/profile_model.dart';
import 'profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  @override
  Future<ProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const ProfileModel.empty();
  }

  @override
  Future<void> updateChildName(String name) async {}

  @override
  Future<void> updateAvatarPath(String path) async {}
}
