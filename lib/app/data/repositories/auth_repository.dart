abstract class AuthRepository {
  Future<String> getParentPhoneMasked();

  Future<bool> verifyOtp(String code);
}
