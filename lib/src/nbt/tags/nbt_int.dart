import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_tag.dart';

/// Represents a 4 byte integer in a NBT file.
class NbtInt extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtInt] with given [parent].
  NbtInt({required String name, required int value})
      : _value = value,
        super(name, NbtTagType.TAG_INT);

  @override
  NbtInt readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName ? nbtReader.readString() : 'None';
    final value = nbtReader.readInt(signed: true);
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
    nbtWriter.writeInt(_value, signed: true);
  }
}
