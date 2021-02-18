import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';
import 'nbt_tag.dart';

/// Represents a list of unnamed [NbtTag]s. Can only be a single type of [NbtTag],
/// e.g. only a list of [NbtInt].
class NbtList<T extends NbtTag> extends NbtArray<T> {
  /// Creates a basic [NbtList] with given [name] and [parent]. [nbtTagType] defaults to [NbtTagType.TAG_LIST] and only
  /// [NbtTagType.TAG_COMPOUND] or [NbtTagType.TAG_LIST] should be used here.
  NbtList(String name, NbtTag parent, [NbtTagType nbtTagType = NbtTagType.TAG_LIST]) : super(parent, nbtTagType) {
    if (!(nbtTagType == NbtTagType.TAG_LIST || nbtTagType == NbtTagType.TAG_COMPOUND)) throw ArgumentError('nbtTagType must be TAG_LIST or TAG_COMPOUND.');
    this.name = name;
  }

  /// Reads a [NbtList] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtList.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final nbtList = NbtList(name, parent);

    final tagType = fileReader.readByte();
    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      nbtList.add(NbtTag.readTagForType(fileReader, tagType, nbtList, withName: false));
    }

    return nbtList;
  }
}
