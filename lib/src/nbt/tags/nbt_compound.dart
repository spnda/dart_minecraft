import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_list.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

import '../nbt_file_reader.dart';

/// Represents a list of named [NbtTag]s. Unlike [NbtList], this can have 
/// any type of [NbtTag] in its list.
class NbtCompound<T extends NbtTag> extends NbtList<T> {
  /// Get a list of children that have given [name].
  List<T> getChildrenByName(String name) => where((tag) => tag.name == name).toList();

  /// Get a list of children 
  List<T> getChildrenByTag(NbtTagType tagType) => where((tag) => tag.nbtTagType == tagType).toList();

  NbtCompound(String name, NbtTag parent) : super(name, parent, NbtTagType.TAG_COMPOUND);

  factory NbtCompound.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    final nbtCompound = NbtCompound(name, parent);

    NbtTag tag;
    while ((tag = NbtTag.readTag(fileReader, nbtCompound)).nbtTagType != NbtTagType.TAG_END) {
      nbtCompound.add(tag);
    }

    return nbtCompound;
  }
}
