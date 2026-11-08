/// Abstract email/password authentication boundary.
///
/// Implementations must translate provider errors into `AuthFailure` so the rest
/// of the app only deals with friendly Arabic messages. The concrete
/// implementation (`FirebaseAuthRepository`) is chosen in the binding only.
abstract class AuthRepository {
  /// Emits the signed-in user id, or `null` when nobody is signed in.
  Stream<String?> get authStateChanges;

  /// Id of the currently signed-in user, or `null`.
  ///
  /// Backed by the provider's cached session, so it also answers offline.
  String? get currentUserId;

  /// Creates the account of [email]/[password] and its `users/{uid}` profile.
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Signs in an existing account.
  Future<void> signIn({required String email, required String password});

  /// Signs the current user out.
  Future<void> signOut();
}
