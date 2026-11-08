class WorkshopModel {
  const WorkshopModel({
    required this.id,
    required this.title,
    required this.location,
    required this.date,
    required this.time,
    required this.supervisor,
    required this.ageRange,
    required this.remainingSpots,
    required this.description,
    required this.activities,
  });

  final String id;
  final String title;
  final String location;
  final String date;
  final String time;
  final String supervisor;
  final String ageRange;
  final int remainingSpots;
  final String description;
  final List<String> activities;
}
