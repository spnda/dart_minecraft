import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

import '../nbt_file_reader.dart';

/// Represents a 4 byte single precision floating point number in a NBT file.
class NbtFloat extends NbtTag {
  double _value;

  @override
  double get value => _value;

  /// Creates a [NbtFloat] with given name and value.
  NbtFloat(String name, this._value, NbtTag parent) : super(parent, NbtTagType.TAG_FLOAT) {
    this.name = name;
  }

  factory NbtFloat.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final value = fileReader.readFloat();
    return NbtFloat(name, value, parent);
  }
}
