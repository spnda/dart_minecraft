import 'package:dart_minecraft/src/exceptions/nbt_exception.dart';

class NbtFileReadException implements NbtException {
  @override
  final String message;

  /// A Exception representing some exception when
  /// reading a NBT file.
  NbtFileReadException(this.message);

  @override
  String toString() {
    return 'NbtFileReadException: $message';
  }
}
