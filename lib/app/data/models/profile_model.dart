class ProfileModel {
  const ProfileModel({
    required this.fullName,
    required this.grade,
    required this.parentPhone,
    required this.address,
    required this.examResults,
    required this.assignments,
    required this.classSchedule,
    required this.notices,
  });

  final String fullName;
  final String grade;
  final String parentPhone;
  final String address;
  final List<String> examResults;
  final List<String> assignments;
  final List<String> classSchedule;
  final List<String> notices;
}
