class NbtFileReadException implements Exception {
  /// A human-readable descriptive error message.
  final String message;

  /// A Exception representing some exception when
  /// reading a NBT file.
  NbtFileReadException(this.message);

  @override
  String toString() {
    return 'NbtFileReadException: $message';
  }
}
