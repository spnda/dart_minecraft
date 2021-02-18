import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 8 byte long integer in a NBT file.
class NbtLong extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtInt] with given name and value.
  NbtLong(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_LONG) {
    this.name = name;
  }

  /// Reads a [NbtLong] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtLong.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readLong();
    return NbtLong(name, value, parent);
  }
}
