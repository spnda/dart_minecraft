import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';

/// Represents a array of single byte integers in a NBT file.
class NbtByteArray extends NbtArray<int> {
  /// Create a [NbtByteArray]. To load any values, call [readTag].
  NbtByteArray({required String name, required List<int> children})
      : super(name, NbtTagType.TAG_BYTE_ARRAY) {
    this.children = children;
  }

  @override
  NbtByteArray readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName
        ? fileReader.readString()
        : 'None'; // On the root node, this should be a empty string
    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      add(fileReader.readByte(signed: true));
    }
    return this..name = name;
  }

  @override
  void writeTag(NbtFileWriter fileWriter,
      {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeInt(children.length, signed: true);
    for (final val in children) {
      fileWriter.writeByte(val, signed: true);
    }
  }
}
