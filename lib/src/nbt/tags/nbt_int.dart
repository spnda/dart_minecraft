import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

import '../nbt_file_reader.dart';

/// Represents a 4 byte integer in a NBT file.
class NbtInt extends NbtTag {
  int _value;

  @override
  int get value => _value;

  /// Creates a [NbtInt] with given name and value.
  NbtInt(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_INT) {
    this.name = name;
  }

  factory NbtInt.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readInt();
    return NbtInt(name, value, parent);
  }
}
