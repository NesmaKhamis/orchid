import '../models/profile_model.dart';
import 'profile_repository.dart';

class MockProfileRepository implements ProfileRepository {
  static const ProfileModel _profile = ProfileModel(
    fullName: 'ليان أحمد',
    grade: 'الصف السابع - أ',
    parentPhone: '٠٥٥ ١٢٣ ٤٥٦٧',
    address: 'حي الورد، الرياض',
    examResults: <String>[
      'الرياضيات — ٩٢ / ١٠٠',
      'اللغة العربية — ٩٥ / ١٠٠',
      'العلوم — ٨٨ / ١٠٠',
    ],
    assignments: <String>[
      'قراءة الفصل الثالث من كتاب اللغة العربية',
      'حل تمارين الرياضيات صفحة ٢٤',
      'إحضار دفتر العلوم للحصة القادمة',
    ],
    classSchedule: <String>[
      'الأحد • ٨:٠٠ — الرياضيات',
      'الاثنين • ٩:٠٠ — اللغة العربية',
      'الثلاثاء • ١٠:٠٠ — العلوم',
    ],
    notices: <String>[
      'يبدأ اليوم الدراسي الساعة ٧:٣٠ صباحاً.',
      'يرجى إحضار الأدوات الفنية يوم الأربعاء.',
    ],
  );

  @override
  Future<ProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _profile;
  }

  @override
  Future<ProfileModel> getFallbackProfile() async => _profile;
}
