import '../nbt_reader.dart';
import '../nbt_tags.dart';
import '../nbt_writer.dart';
import 'nbt_compound.dart';
import 'nbt_tag.dart';

/// Represents the end tag of a [NbtCompound] list. This tag
/// does not include any name or value.
class NbtEnd extends NbtTag {
  @override
  String get name => '';

  @override
  int get value => 0;

  /// Creates a single [NbtEnd] tag, which should be at the end of a
  /// [NbtCompound] and does not contain any payload or name.
  NbtEnd(NbtCompound parent) : super('', NbtTagType.TAG_END) {
    this.parent = parent;
  }

  @override
  NbtTag readTag(NbtReader nbtReader, {bool withName = true}) {
    if (nbtReader.readByte() != 0x00) throw Exception('Cannot read end tag.');
    return this;
  }

  @override
  void writeTag(NbtWriter nbtWriter,
      {bool withName = true, bool withType = true}) {
    nbtWriter.writeByte(0x00);
  }
}
