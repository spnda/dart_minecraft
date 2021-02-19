import 'package:dart_minecraft/src/nbt/nbt_file_writer.dart';

import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 4 byte integer in a NBT file.
class NbtInt extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtInt] with given [parent].
  NbtInt(NbtTag parent) : super.value(parent, NbtTagType.TAG_INT);

  @override
  NbtInt readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readInt();
    return this..name = name.._value = value;
  }

  @override
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeInt(_value);
  }
}
