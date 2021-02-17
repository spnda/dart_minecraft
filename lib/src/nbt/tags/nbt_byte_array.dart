import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_array.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

import '../nbt_file_reader.dart';

/// Represents a array of 4 byte integers in a NBT file.
class NbtByteArray extends NbtArray<int> {
  NbtByteArray(String name, NbtTag parent) : super(parent, NbtTagType.TAG_BYTE_ARRAY) {
    this.name = name;
  }

  factory NbtByteArray.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final nbtList = NbtByteArray(name, parent);

    final length = fileReader.readInt(true);
    for (var i = 0; i < length; i++) {
      nbtList.add(fileReader.readByte(true));
    }

    return nbtList;
  }
}
