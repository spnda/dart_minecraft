abstract class NbtException implements Exception {
  /// A human-readable descriptive error message.
  final String message;

  NbtException(this.message);
}
