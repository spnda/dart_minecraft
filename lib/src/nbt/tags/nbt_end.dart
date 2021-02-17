import 'package:dart_minecraft/src/nbt/nbt_tags.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_compound.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_tag.dart';

/// Represents the end tag of a [NbtCompound] list.
class NbtEnd extends NbtTag {
  @override
  String get name => '';

  @override
  int get value => 0;

  NbtEnd(NbtCompound parent) : super(parent, NbtTagType.TAG_END);
}
