import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_array.dart';

/// Represents a array of 4 byte integers in a NBT file.
class NbtIntArray extends NbtArray<int> {
  /// Create a [NbtIntArray] with given [parent].
  NbtIntArray({required String name, required List<int> children})
      : super(name, NbtTagType.TAG_INT_ARRAY) {
    this.children = children;
  }

  @override
  NbtIntArray readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName ? nbtReader.readString() : 'None';
    final length = nbtReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      add(nbtReader.readInt(signed: true));
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
      nbtWriter.writeInt(val, signed: true);
    }
  }
}
