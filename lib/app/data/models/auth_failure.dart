/// Domain-level authentication failure carrying a ready-to-show Arabic message.
///
/// Repositories translate SDK exceptions (e.g. `FirebaseAuthException`) into this
/// type so controllers and views never depend on provider-specific error codes.
class AuthFailure implements Exception {
  const AuthFailure(this.message, {this.code});

  /// Friendly Arabic message, safe to show through `AppSnackbar`.
  final String message;

  /// Original provider error code, kept for logging and diagnostics only.
  final String? code;

  @override
  String toString() => 'AuthFailure(code: $code, message: $message)';
}
