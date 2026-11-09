/// Business constants.
class AppConstants {
  AppConstants._();

  static const int minChildAge = 5;
  static const int maxChildAge = 12;
  static const int otpLength = 6;
  static const int otpResendSeconds = 60;
  static const int minPasswordLength = 6;
  static const int emailVerificationResendSeconds = 60;
  static const Duration splashMinDuration = Duration(milliseconds: 2500);

  /// Daily coin earning cap to encourage healthy screen habits.
  static const int dailyCoinCap = 50;

  /// Coins awarded per activity.
  static const int moodCheckInCoins = 10;
  static const int drawingCoins = 10;
  static const int coloringCoins = 10;
  static const int singingCoins = 10;
  static const int workshopCoins = 20;

  /// Firestore collection holding one profile document per Firebase user.
  static const String usersCollection = 'users';
}
