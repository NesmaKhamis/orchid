import 'auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  @override
  String get currentEmail => 'nesma@gmail.com';

  @override
  Future<void> sendEmailVerification() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // TODO: replace with FirebaseAuth currentUser.sendEmailVerification().
  }

  @override
  Future<bool> reloadAndCheckVerified() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // TODO: replace with FirebaseAuth currentUser.reload() / emailVerified.
    return true;
  }
}
