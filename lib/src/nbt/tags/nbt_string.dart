import 'package:dart_minecraft/src/nbt/nbt_tags.dart';

import '../nbt_file_reader.dart';
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

  factory NbtString.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readString();
    return NbtString(name, value, parent);
  }
}
