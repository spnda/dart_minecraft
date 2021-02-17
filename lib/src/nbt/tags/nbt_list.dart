import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_array.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

import '../nbt_file_reader.dart';

/// Represents a list of unnamed [NbtTag]s. Can only be a single type of [NbtTag],
/// e.g. only a list of [NbtInt].
class NbtList<T extends NbtTag> extends NbtArray<T> {
  NbtList(String name, NbtTag parent, [NbtTagType nbtTagType = NbtTagType.TAG_LIST]) : super(parent, nbtTagType) {
    this.name = name;
  }

  factory NbtList.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final nbtList = NbtList(name, parent);

    final tagType = fileReader.readByte();
    final length = fileReader.readInt(true);
    for (var i = 0; i < length; i++) {
      nbtList.add(NbtTag.readTagForType(fileReader, tagType, nbtList, withName: false));
    }

    return nbtList;
  }
}
