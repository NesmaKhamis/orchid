abstract class AuthRepository {
  String get currentEmail;

  Future<void> sendEmailVerification();

  Future<bool> reloadAndCheckVerified();
}
