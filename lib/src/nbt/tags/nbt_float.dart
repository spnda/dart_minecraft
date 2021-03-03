import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 4 byte single precision floating point number in a NBT file.
class NbtFloat extends NbtTag {
  double _value;

  @override
  double get value => _value;

  /// Creates a [NbtFloat] with given [parent].
  NbtFloat({required String name, required double value})
      : _value = value,
        super(name, NbtTagType.TAG_FLOAT);

  @override
  NbtFloat readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readFloat();
    return this
      ..name = name
      .._value = value;
  }

  @override
  void writeTag(NbtFileWriter fileWriter,
      {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeFloat(_value);
  }
}
