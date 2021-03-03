import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 8 byte double precision floating point number in a NBT file.
class NbtDouble extends NbtTag {
  double _value;

  @override
  double get value => _value;

  /// Creates a [NbtDouble] with given [parent].
  NbtDouble({required String name, required double value})
      : _value = value,
        super(name, NbtTagType.TAG_DOUBLE);

  @override
  NbtDouble readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readDouble();
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
    fileWriter.writeDouble(_value);
  }
}
