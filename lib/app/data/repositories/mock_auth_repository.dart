import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<String> getParentPhoneMasked() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return '+970 59 ••• •• 42';
  }

  @override
  Future<bool> verifyOtp(String code) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with Firebase phone authentication.
    return code == '123456';
  }
}
