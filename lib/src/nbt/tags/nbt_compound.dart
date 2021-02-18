import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_list.dart';
import 'nbt_tag.dart';

/// Represents a list of named [NbtTag]s. Unlike [NbtList], this can have 
/// any type of [NbtTag] in its list.
class NbtCompound<T extends NbtTag> extends NbtList<T> {
  /// Get a list of children that have given [name].
  List<T> getChildrenByName(String name) => where((tag) => tag.name == name).toList();

  /// Get a list of children 
  List<T> getChildrenByTag(NbtTagType tagType) => where((tag) => tag.nbtTagType == tagType).toList();

  /// Create a [NbtCompound] with given [name] and [parent].
  NbtCompound(String name, NbtTag parent) : super(name, parent, NbtTagType.TAG_COMPOUND);

  /// Reads a [NbtCompound] and all its children with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
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
