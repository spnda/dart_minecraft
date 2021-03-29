import 'package:dart_minecraft/src/exceptions/nbt_exception.dart';

class NbtFileWriteException implements NbtException {
  @override
  final String message;

  /// Thrown when we encounter an issue writing
  /// NBT to a file.
  NbtFileWriteException(this.message);

  @override
  String toString() {
    return 'NbtFileWriteException: $message';
  }
}
