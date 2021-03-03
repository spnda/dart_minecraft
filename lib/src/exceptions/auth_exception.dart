/// Thrown when invalid credentials are passed to any
/// authentication service.
class AuthException implements Exception {
  static const invalidCredentialsMessage =
      'Unauthorized (Bearer token expired or is not correct).';

  /// The exact error message.
  final String message;

  /// A Exception representing some error caused by
  /// invalid credentials on a Web-API.
  AuthException(this.message);

  @override
  String toString() {
    return 'AuthException: $message';
  }
}
