import 'package:dart_minecraft/src/nbt/tags/nbt_compound.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_int.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_long.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_string.dart';
import 'package:dart_minecraft/src/nbt/tags/nbt_list.dart';

import '../nbt_file_reader.dart';
import '../nbt_tags.dart';
import 'nbt_byte.dart';
import 'nbt_byte_array.dart';
import 'nbt_double.dart';
import 'nbt_end.dart';
import 'nbt_float.dart';
import 'nbt_int_array.dart';
import 'nbt_long_array.dart';
import 'nbt_short.dart';

/// Represents the base of any NBT Tag.
abstract class NbtTag {
  /// This tags type.
  NbtTagType _nbtTagType;

  /// This tags parent.
  NbtTag _parent;

  /// The name of this tag. Inside of Lists or Arrays, this
  /// is 'None'.
  String name;

  /// The value of this tag. Can vary depending on tag type,
  /// obtainable from [nbtTagType].
  dynamic get value;

  /// The parent of this tag. Can only be null for the root
  /// NbtCompound.
  NbtTag get parent => _parent;

  /// The type of this tag.
  NbtTagType get nbtTagType => _nbtTagType;

  /// If this tag directly has a value.
  bool get hasValue {
    switch (nbtTagType) {
      case NbtTagType.TAG_END:
      case NbtTagType.TAG_COMPOUND:
      case NbtTagType.TAG_LIST:
        return false;
      default: 
        return true;
    }
  }

  /// If the tag is a List and has a length
  bool get hasLength {
    switch (nbtTagType) {
      case NbtTagType.TAG_LIST:
      case NbtTagType.TAG_BYTE_ARRAY:
      case NbtTagType.TAG_INT_ARRAY:
      case NbtTagType.TAG_LONG_ARRAY:
        return true;
      default:
        return false;
    }
  }

  NbtTag(this._parent, this._nbtTagType);

  /// Reads the next byte and uses that value for [NbtTag.readTagForType].
  factory NbtTag.readTag(NbtFileReader fileReader, NbtTag parent, {bool withName = true}) {
    final data = fileReader.readByte();
    return NbtTag.readTagForType(fileReader, data, parent);
  }

  /// Reads the Tag with type [tagType].
  factory NbtTag.readTagForType(NbtFileReader fileReader, int tagType, NbtTag parent, {bool withName = true}) {
    switch (tagType) {
      case 0x00: return NbtEnd(parent);
      case 0x01: return NbtByte.readTag(fileReader, parent, withName: withName);
      case 0x02: return NbtShort.readTag(fileReader, parent, withName: withName);
      case 0x03: return NbtInt.readTag(fileReader, parent, withName: withName);
      case 0x04: return NbtLong.readTag(fileReader, parent, withName: withName);
      case 0x05: return NbtFloat.readTag(fileReader, parent, withName: withName);
      case 0x06: return NbtDouble.readTag(fileReader, parent, withName: withName);
      case 0x07: return NbtByteArray.readTag(fileReader, parent, withName: withName);
      case 0x08: return NbtString.readTag(fileReader, parent, withName: withName);
      case 0x09: return NbtList.readTag(fileReader, parent, withName: withName);
      case 0x0A: return NbtCompound.readTag(fileReader, parent, withName: withName);
      case 0x0B: return NbtIntArray.readTag(fileReader, parent, withName: withName);
      case 0x0C: return NbtLongArray.readTag(fileReader, parent, withName: withName);
      default: return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (!(other is NbtTag)) return false;
    final tag = other as NbtTag;
    if (tag.nbtTagType != nbtTagType) return false; // Different IDs, different tags
    if (name == null && tag.name != null || name != null && tag.name == null) return false; // Different names
    if (name != null && name != tag.name) return false;
    return true;
  }

  @override
  String toString() {
    return '${nbtTagType.asString()}($name): $value';
  }
}
