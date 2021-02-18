import '../nbt_tags.dart';
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
  NbtEnd(NbtCompound parent) : super(parent, NbtTagType.TAG_END);
}
