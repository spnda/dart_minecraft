import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 2 byte short integer in a NBT file.
class NbtShort extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtShort] with given name and a default value of 0.
  NbtShort(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_SHORT) {
    this.name = name;
  }

  /// Reads a [NbtShort] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtShort.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readShort();
    return NbtShort(name, value, parent);
  }
}
