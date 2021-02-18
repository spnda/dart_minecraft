import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_array.dart';
import 'nbt_tag.dart';

/// Represents a array of 8 byte long integers in a NBT file.
class NbtLongArray extends NbtArray<int> {
  /// Create a [NbtLongArray] with given [name] and [parent].
  NbtLongArray(String name, NbtTag parent) : super(parent, NbtTagType.TAG_LONG_ARRAY) {
    this.name = name;
  }
  
  /// Reads a [NbtLongArray] with given [fileReader] and given [parent]. 
  /// If inside a [NbtList] or [NbtArray], [withName] should be set to false to avoid reading
  /// the name of this Tag.
  factory NbtLongArray.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final name = withName ? fileReader.readString() : 'None'; // On the root node, this should be a empty string
    final nbtList = NbtLongArray(name, parent);

    final length = fileReader.readInt(signed: true);
    for (var i = 0; i < length; i++) {
      nbtList.add(fileReader.readLong(signed: true));
    }

    return nbtList;
  }
}
