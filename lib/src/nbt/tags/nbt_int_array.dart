import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';

/// Represents a array of 4 byte integers in a NBT file.
class NbtIntArray extends NbtArray<int> {
  /// Create a [NbtIntArray] with given [parent].
  NbtIntArray({required String name, required List<int> children}) : super(name, NbtTagType.TAG_INT_ARRAY) {
    this.children = children;
  }

  @override
  NbtIntArray readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      add(fileReader.readInt(signed: true));
    }
    return this..name = name;
  }

  @override
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    for (final val in children) {
      fileWriter.writeInt(val, signed: true);
    }
  }
}
