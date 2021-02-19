import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a String inside a NBT File.
class NbtString extends NbtTag {
  String _value;

  @override
  String get value => _value;

  /// Creates a [NbtString] with given [parent].
  NbtString(NbtTag parent) : super.value(parent, NbtTagType.TAG_STRING);

  @override
  NbtString readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readString();
    return this..name = name.._value = value;
  }

  @override
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeString(_value);
  }
}
