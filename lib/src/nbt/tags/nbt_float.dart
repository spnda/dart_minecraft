import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
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
  NbtFloat readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName ? nbtReader.readString() : 'None';
    final value = nbtReader.readFloat();
    return this
      ..name = name
      .._value = value;
  }

  @override
  void writeTag(NbtWriter nbtWriter,
      {bool withName = true, bool withType = true}) {
    if (withType) nbtWriter.writeByte(nbtTagType.index);
    if (withName) {
      nbtWriter.writeString(name);
    }
    nbtWriter.writeFloat(_value);
  }
}
