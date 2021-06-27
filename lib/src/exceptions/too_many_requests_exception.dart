/// Thrown when the rate limit for a endpoint has been exceeded.
class TooManyRequestsException implements Exception {
  String message;

  TooManyRequestsException(this.message);

  @override
  String toString() {
    return 'TooManyRequestsException: $message';
  }
}
