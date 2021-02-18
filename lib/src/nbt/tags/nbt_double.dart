import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 8 byte double precision floating point number in a NBT file.
class NbtDouble extends NbtTag {
  double _value;

  @override
  double get value => _value;

  /// Creates a [NbtDouble] with given name and value.
  NbtDouble(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_DOUBLE) {
    this.name = name;
  }

  /// Reads a [NbtDouble] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtDouble.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readDouble();
    return NbtDouble(name, value, parent);
  }
}
