class PingException implements Exception {
  final String message;

  PingException(this.message);

  @override
  String toString() {
    return 'PingException: $message';
  }
}
