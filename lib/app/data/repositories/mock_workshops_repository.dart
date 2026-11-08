import '../models/workshop_model.dart';
import 'workshops_repository.dart';

class MockWorkshopsRepository implements WorkshopsRepository {
  final Set<String> _bookedWorkshopIds = <String>{};

  static const List<WorkshopModel> _workshops = <WorkshopModel>[
    WorkshopModel(
      id: 'feelings-colors',
      title: 'ألوان مشاعري',
      location: 'مركز الأوركيد - قاعة الياسمين',
      date: 'السبت 24 أكتوبر',
      time: '10:00 صباحاً - 11:30 صباحاً',
      supervisor: 'الأخصائية سارة العتيبي',
      ageRange: 'من 5 إلى 8 سنوات',
      remainingSpots: 4,
      description:
          'نكتشف مشاعرنا من خلال الألوان والحكايات والأنشطة الفنية الهادئة، '
          'ثم نتعلم طرقاً بسيطة للتعبير عما نشعر به.',
      activities: <String>[
        'التعرف على المشاعر وتسميتها',
        'نشاط فني للتعبير عن الشعور',
        'تمرين تنفس واسترخاء بسيط',
      ],
    ),
    WorkshopModel(
      id: 'play-together',
      title: 'نلعب ونتعاون',
      location: 'مركز الأوركيد - قاعة النخيل',
      date: 'الأحد 25 أكتوبر',
      time: '4:00 عصراً - 5:30 مساءً',
      supervisor: 'المعالج خالد الحربي',
      ageRange: 'من 8 إلى 12 سنة',
      remainingSpots: 7,
      description:
          'مساحة آمنة للعب الجماعي والتعاون. نمارس مهارات الاستماع، '
          'حل المشكلات، وبناء الصداقات بطريقة ممتعة.',
      activities: <String>[
        'ألعاب جماعية لبناء الثقة',
        'تحديات حل المشكلات',
        'حوار قصير عن التعاون',
      ],
    ),
  ];

  @override
  Future<List<WorkshopModel>> getWorkshops() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<WorkshopModel>.unmodifiable(_workshops);
  }

  @override
  Future<void> bookWorkshop({required String workshopId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    _bookedWorkshopIds.add(workshopId);
  }

  @override
  Future<List<WorkshopModel>> getBookedWorkshops() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _workshops
        .where((workshop) => _bookedWorkshopIds.contains(workshop.id))
        .toList(growable: false);
  }

  @override
  Future<bool> isWorkshopBooked({required String workshopId}) async {
    return _bookedWorkshopIds.contains(workshopId);
  }

  @override
  Future<void> cancelBooking({required String workshopId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _bookedWorkshopIds.remove(workshopId);
  }
}
