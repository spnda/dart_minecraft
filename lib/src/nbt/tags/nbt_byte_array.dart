import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';
import 'nbt_tag.dart';

/// Represents a array of 4 byte integers in a NBT file.
class NbtByteArray extends NbtArray<int> {
  /// Create a [NbtIntArray] with given [name] and [parent].
  NbtByteArray(String name, NbtTag parent) : super(parent, NbtTagType.TAG_BYTE_ARRAY) {
    this.name = name;
  }

  /// Reads a [NbtIntArray] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtByteArray.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final nbtList = NbtByteArray(name, parent);

    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      nbtList.add(fileReader.readByte(signed: true));
    }

    return nbtList;
  }
}
