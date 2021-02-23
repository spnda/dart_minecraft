import '../nbt_file_reader.dart';
import '../nbt_file_writer.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';
import 'nbt_tag.dart';

/// Represents a list of unnamed [NbtTag]s. Can only be a single type of [NbtTag],
/// e.g. only a list of [NbtInt].
class NbtList<T extends NbtTag> extends NbtArray<T> {
  /// Set a new value to this list's children. Automatically adds [this] as the
  /// parent of each item in given list [val].
  set value(List<T> val) {
    for (final tag in val) {
      tag.parent = this;
    }
    children = val;
  }

  /// The [NbtTagType] for all of the children of this list.
  NbtTagType childrenTagType = NbtTagType.TAG_END;

  /// Creates a basic [NbtList] with given [parent]. [nbtTagType] defaults to [NbtTagType.TAG_LIST] and only
  /// [NbtTagType.TAG_COMPOUND] or [NbtTagType.TAG_LIST] should be used here.
  NbtList({required String name, required List<T> children, NbtTagType nbtTagType = NbtTagType.TAG_LIST}) : super(name, nbtTagType) {
    if (!(nbtTagType == NbtTagType.TAG_LIST || nbtTagType == NbtTagType.TAG_COMPOUND)) throw ArgumentError('nbtTagType must be TAG_LIST or TAG_COMPOUND.');

    /// Assign this as the parent of all children.
    /// Also, filter all NbtEnd tags, as they're invalid.
    this.children = (children)
      .map((child) => child..parent = this).toList()
      .where((child) => child.nbtTagType != NbtTagType.TAG_END).toList();
  }

  @override
  NbtList readTag(NbtFileReader fileReader, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final tagType = fileReader.readByte();
    childrenTagType = NbtTagType.values[tagType];
    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      final tag = NbtTag.readTagForType(fileReader, tagType, this, withName: false);
      if (tag != null && tag is T) add(tag);
    }
    return this..name = name;
  }

  @override
  void writeTag(NbtFileWriter fileWriter, {bool withName = true, bool withType = true}) {
    if (withType) fileWriter.writeByte(nbtTagType.index);
    if (withName) {
      fileWriter.writeString(name);
    }
    fileWriter.writeByte(childrenTagType.index);
    fileWriter.writeInt(children.length, signed: true);
    for (final val in children) {
      val.writeTag(fileWriter, withName: false, withType: false);
    }
  }
}
