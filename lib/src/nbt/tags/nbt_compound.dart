import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_end.dart';
import 'nbt_list.dart';
import 'nbt_tag.dart';

/// Represents a list of named [NbtTag]s. Unlike [NbtList], this can have
/// any type of [NbtTag] in its list.
class NbtCompound<T extends NbtTag> extends NbtList<T> {
  /// Get a list of children that have given [name].
  List<T> getChildrenByName(String name) =>
      where((tag) => tag.name == name).toList();

  /// Get a list of children
  List<T> getChildrenByTag(NbtTagType tagType) =>
      where((tag) => tag.nbtTagType == tagType).toList();

  /// Create a [NbtCompound] with given [parent].
  NbtCompound({required super.name, required super.children})
      : super(
            nbtTagType: NbtTagType.TAG_COMPOUND);

  @override
  NbtCompound readTag(NbtReader nbtReader, {bool withName = true}) {
    final name = withName ? nbtReader.readString() : 'None';
    var tag =
        NbtTag.readTagForType(nbtReader, nbtReader.readByte(), parent: this);

    while (tag != null && tag.nbtTagType != NbtTagType.TAG_END) {
      if (tag is T) add(tag);
      tag =
          NbtTag.readTagForType(nbtReader, nbtReader.readByte(), parent: this);
    }
    return this..name = name;
  }

  @override
  void writeTag(NbtWriter nbtWriter,
      {bool withName = true, bool withType = true}) {
    if (withType) nbtWriter.writeByte(nbtTagType.index);
    if (withName) {
      nbtWriter.writeString(name);
    }
    for (final val in children) {
      val.writeTag(nbtWriter, withName: true, withType: true);
    }
    // Write the last NbtEnd tag as well, this one is not included in [children].
    NbtEnd(this).writeTag(nbtWriter);
  }
}
