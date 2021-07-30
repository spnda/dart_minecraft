import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_array.dart';

/// Represents a array of 8 byte long integers in a NBT file.
class NbtLongArray extends NbtArray<int> {
  /// Create a [NbtLongArray] with given [parent].
  NbtLongArray({required String name, required List<int> children})
      : super(name, NbtTagType.TAG_LONG_ARRAY) {
    this.children = children;
  }

  @override
  NbtLongArray readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName ? nbtReader.readString() : 'None';
    final length = nbtReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      add(nbtReader.readLong(signed: true));
    }
    return this..name = name;
  }

  @override
  void writeTag(NbtWriter nbtWriter,
      {bool withName = true, bool withType = true}) {
    if (withType) nbtWriter.writeByte(nbtTagType.index);
    if (withName) {
      nbtWriter.writeString(name);
    }
    nbtWriter.writeInt(children.length, signed: true);
    for (final val in children) {
      nbtWriter.writeLong(val, signed: true);
    }
  }
}
