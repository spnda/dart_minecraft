import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_tag.dart';

/// Represents a 8 byte long integer in a NBT file.
class NbtLong extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtLong] with given [parent].
  NbtLong({required String name, required int value})
      : _value = value,
        super(name, NbtTagType.TAG_LONG);

  @override
  NbtLong readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName ? nbtReader.readString() : 'None';
    final value = nbtReader.readLong(signed: true);
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
    nbtWriter.writeLong(_value, signed: true);
  }
}
