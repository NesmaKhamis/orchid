import '../models/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel> getProfile();

  Future<void> updateChildName(String name);

  Future<void> updateAvatarPath(String path);
}
