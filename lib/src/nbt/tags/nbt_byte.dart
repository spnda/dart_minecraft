import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a single byte in a NBT file.
class NbtByte extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtByte] with given name and value.
  NbtByte(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_BYTE) {
    this.name = name;
  }

  /// Reads a [NbtByte] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtByte.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readByte();
    
    return NbtByte(name, value, parent);
  }
}
