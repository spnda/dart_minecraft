import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_tag.dart';

/// Represents a String inside a NBT File.
class NbtString extends NbtTag {
  String _value;

  @override
  String get value => _value;
  
  /// Creates a [NbtString] with given name and a default value of 0.
  NbtString(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_STRING) {
    this.name = name;
  }

  /// Reads a [NbtString] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtString.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readString();
    return NbtString(name, value, parent);
  }
}
