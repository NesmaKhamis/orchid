/// Business constants.
class AppConstants {
  AppConstants._();

  static const int minChildAge = 5;
  static const int maxChildAge = 12;
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;
  static const int minPasswordLength = 6;
  static const Duration splashMinDuration = Duration(milliseconds: 2500);

  /// Firestore collection holding one profile document per Firebase user.
  static const String usersCollection = 'users';
}
