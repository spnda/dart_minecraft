import 'package:dart_minecraft/src/nbt/nbt_file_reader.dart';
import 'package:dart_minecraft/src/nbt/nbt_tags.dart';

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

  factory NbtByte.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readByte();
    
    return NbtByte(name, value, parent);
  }
}
