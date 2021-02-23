import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a single byte in a NBT file.
class NbtByte extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtByte] with given [parent].
  NbtByte({required String name, required int value}) : _value = value, super(name, NbtTagType.TAG_BYTE);

  @override
  NbtByte readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readByte();
    return this..name = name.._value = value;
  }

  @override
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeByte(_value);
  }
}
