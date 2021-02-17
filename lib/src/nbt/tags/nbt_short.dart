import 'package:dart_minecraft/src/nbt/nbt_file_reader.dart';
import 'package:dart_minecraft/src/nbt/nbt_tags.dart';

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

  factory NbtShort.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readShort();
    return NbtShort(name, value, parent);
  }
}
