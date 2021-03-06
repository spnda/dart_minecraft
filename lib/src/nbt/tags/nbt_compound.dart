import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
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
  NbtCompound({required String name, required List<T> children})
      : super(
            name: name,
            children: children,
            nbtTagType: NbtTagType.TAG_COMPOUND);

  @override
  NbtCompound readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None';
    var tag =
        NbtTag.readTagForType(fileReader, fileReader.readByte(), parent: this);

    while (tag != null && tag.nbtTagType != NbtTagType.TAG_END) {
      if (tag is T) add(tag);
      tag = NbtTag.readTagForType(fileReader, fileReader.readByte(),
          parent: this);
    }
    return this..name = name;
  }

  @override
  void writeTag(NbtFileWriter fileWriter,
      {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    for (final val in children) {
      val.writeTag(fileWriter, withName: true, withType: true);
    }
    // Write the last NbtEnd tag as well, this one is not included in [children].
    NbtEnd(this).writeTag(fileWriter);
  }
}
