import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_array.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

import '../nbt_file_reader.dart';

/// Represents a array of 4 byte integers in a NBT file.
class NbtIntArray extends NbtArray<int> {
  NbtIntArray(String name, NbtTag parent) : super(parent, NbtTagType.TAG_INT_ARRAY) {
    this.name = name;
  }

  factory NbtIntArray.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final nbtList = NbtIntArray(name, parent);

    final length = fileReader.readInt(true);
    for (var i = 0; i < length; i++) {
      nbtList.add(fileReader.readInt(true));
    }

    return nbtList;
  }
}
