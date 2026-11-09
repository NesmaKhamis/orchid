/// Date utilities.
class AppDateUtils {
  AppDateUtils._();

  static int ageFrom(DateTime birthDate) {
    final DateTime now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  static String format(DateTime date) {
    final String year = date.year.toString().padLeft(4, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// Relative Arabic time string (e.g. 'الآن', 'قبل ساعة', 'أمس', 'قبل أسبوع').
  static String relativeTime(DateTime dateTime) {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(dateTime);

    if (diff.isNegative || diff.inMinutes < 1) {
      return 'الآن';
    } else if (diff.inMinutes < 60) {
      final int m = diff.inMinutes;
      if (m == 1) return 'قبل دقيقة';
      if (m == 2) return 'قبل دقيقتين';
      if (m <= 10) return 'قبل $m دقائق';
      return 'قبل $m دقيقة';
    } else if (diff.inHours < 24) {
      final int h = diff.inHours;
      if (h == 1) return 'قبل ساعة';
      if (h == 2) return 'قبل ساعتين';
      if (h <= 10) return 'قبل $h ساعات';
      return 'قبل $h ساعة';
    } else if (diff.inDays < 7) {
      final int d = diff.inDays;
      if (d == 1) return 'أمس';
      if (d == 2) return 'قبل يومين';
      if (d <= 10) return 'قبل $d أيام';
      return 'قبل $d يوماً';
    } else if (diff.inDays < 30) {
      final int weeks = (diff.inDays / 7).floor();
      if (weeks == 1) return 'قبل أسبوع';
      if (weeks == 2) return 'قبل أسبوعين';
      return 'قبل $weeks أسابيع';
    } else {
      return format(dateTime);
    }
  }
}
