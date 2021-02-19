import 'package:dart_minecraft/src/nbt/nbt_file_writer.dart';

import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';
import 'nbt_tag.dart';

/// Represents a array of 4 byte integers in a NBT file.
class NbtIntArray extends NbtArray<int> {
  /// Create a [NbtIntArray] with given [parent].
  NbtIntArray(NbtTag parent) : super.value(parent, NbtTagType.TAG_INT_ARRAY);

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
