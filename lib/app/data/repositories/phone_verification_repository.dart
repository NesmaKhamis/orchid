/// Phone-verification boundary used by the registration OTP step.
abstract class PhoneVerificationRepository {
  /// Masked parent phone shown under the OTP field.
  Future<String> getParentPhoneMasked();

  /// Validates the OTP entered by the parent.
  Future<bool> verifyOtp(String code);
}
