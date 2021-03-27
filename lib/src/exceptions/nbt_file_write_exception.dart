class NbtFileWriteException implements Exception {
  /// A human-readable descriptive error message.
  final String message;

  /// Thrown when we encounter an issue writing 
  /// NBT to a file.
  NbtFileWriteException(this.message);

  @override
  String toString() {
    return 'NbtFileWriteException: $message';
  }
}
