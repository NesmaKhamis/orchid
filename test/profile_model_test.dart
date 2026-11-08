import 'package:flutter_test/flutter_test.dart';
import 'package:orchid_app/app/data/models/profile_model.dart';

void main() {
  group('ProfileModel', () {
    test('reads and trims profile fields from a Firestore map', () {
      final ProfileModel profile = ProfileModel.fromMap(<String, dynamic>{
        'name': '  ليان أحمد ',
        'photoUrl': '  https://example.com/avatar.png ',
        'phoneNumber': '  +970 59 123 4567 ',
        'address': '  عمّان ',
      });

      expect(profile.childName, 'ليان أحمد');
      expect(profile.avatarPath, 'https://example.com/avatar.png');
      expect(profile.phoneNumber, '+970 59 123 4567');
      expect(profile.address, 'عمّان');
    });

    test('uses the not-specified fallback for empty profile fields', () {
      final ProfileModel profile = ProfileModel.fromMap(<String, dynamic>{});

      expect(profile.displayedChildName, 'اسم الطفل');
      expect(profile.displayedPhoneNumber, 'غير محدد');
      expect(profile.displayedAddress, 'غير محدد');
    });

    test('copies updated name and avatar without losing contact data', () {
      const ProfileModel profile = ProfileModel(
        childName: 'ليان',
        avatarPath: 'assets/images/orchid_single.png',
        phoneNumber: '0591234567',
        address: 'عمّان',
      );

      final ProfileModel updated = profile.copyWith(
        childName: 'نور',
        avatarPath: 'assets/images/orchid_mascot.png',
      );

      expect(updated.childName, 'نور');
      expect(updated.avatarPath, 'assets/images/orchid_mascot.png');
      expect(updated.phoneNumber, profile.phoneNumber);
      expect(updated.address, profile.address);
    });
  });
}
