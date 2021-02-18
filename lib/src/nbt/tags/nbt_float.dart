import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a 4 byte single precision floating point number in a NBT file.
class NbtFloat extends NbtTag {
  double _value;

  @override
  double get value => _value;

  /// Creates a [NbtFloat] with given name and value.
  NbtFloat(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_FLOAT) {
    this.name = name;
  }

  /// Reads a [NbtFloat] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtFloat.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readFloat();
    return NbtFloat(name, value, parent);
  }
}
