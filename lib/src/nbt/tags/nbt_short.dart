import 'package:meta/meta.dart';

import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 2 byte short integer in a NBT file.
class NbtShort extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtShort] with given [parent].
  NbtShort({@required String name, @required int value}) : _value = value, super(name, NbtTagType.TAG_SHORT);

  @override
  NbtShort readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readShort();
    return this..name = name.._value = value;
  }

  @override
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeShort(_value);
  }
}
