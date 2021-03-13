import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';

/// Represents a array of 8 byte long integers in a NBT file.
class NbtLongArray extends NbtArray<int> {
  /// Create a [NbtLongArray] with given [parent].
  NbtLongArray({required String name, required List<int> children})
      : super(name, NbtTagType.TAG_LONG_ARRAY) {
    this.children = children;
  }

  @override
  NbtLongArray readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      add(fileReader.readLong(signed: true));
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
      fileWriter.writeLong(val, signed: true);
    }
  }
}
