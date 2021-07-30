import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_tag.dart';

/// Represents a String inside a NBT File.
class NbtString extends NbtTag {
  String _value;

  @override
  String get value => _value;

  /// Creates a [NbtString] with given [parent].
  NbtString({required String name, required String value})
      : _value = value,
        super(name, NbtTagType.TAG_STRING);

  @override
  NbtString readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName ? nbtReader.readString() : 'None';
    final value = nbtReader.readString();
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
    nbtWriter.writeString(_value);
  }
}
