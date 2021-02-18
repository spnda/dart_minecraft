import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';
import 'nbt_tag.dart';

/// Represents a array of 4 byte integers in a NBT file.
class NbtIntArray extends NbtArray<int> {
  /// Create a [NbtIntArray] with given [name] and [parent].
  NbtIntArray(String name, NbtTag parent) : super(parent, NbtTagType.TAG_INT_ARRAY) {
    this.name = name;
  }

  /// Reads a [NbtIntArray] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtIntArray.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final nbtList = NbtIntArray(name, parent);

    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      nbtList.add(fileReader.readInt(signed: true));
    }

    return nbtList;
  }
}
