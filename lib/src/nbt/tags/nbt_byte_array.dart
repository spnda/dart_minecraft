import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_array.dart';

/// Represents a array of single byte integers in a NBT file.
class NbtByteArray extends NbtArray<int> {
  /// Create a [NbtByteArray]. To load any values, call [readTag].
  NbtByteArray({required String name, required List<int> children})
      : super(name, NbtTagType.TAG_BYTE_ARRAY) {
    this.children = children;
  }

  @override
  NbtByteArray readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName
        ? nbtReader.readString()
        : 'None'; // On the root node, this should be a empty string
    final length = nbtReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      add(nbtReader.readByte(signed: true));
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
      nbtWriter.writeByte(val, signed: true);
    }
  }
}
