/// Different tags for each Nbt Tag that exists.
enum NbtTagType {
  /// A NBT Tag used to indicate the end of a NbtCompound.
  // ignore: constant_identifier_names
  TAG_END,

  /// A named NBT Tag used to store a single byte.
  // ignore: constant_identifier_names
  TAG_BYTE,

  /// A named NBT Tag used to store a single big endian signed 2 byte short integer.
  // ignore: constant_identifier_names
  TAG_SHORT,

  /// A named NBT Tag used to store a single big endian signed 4 byte integer.
  // ignore: constant_identifier_names
  TAG_INT,

  /// A named NBT Tag to store a single big endian signed 8 byte long integer.
  // ignore: constant_identifier_names
  TAG_LONG,

  /// A named NBT Tag used to store a single 4 byte single precision
  /// floating point number.
  // ignore: constant_identifier_names
  TAG_FLOAT,

  /// A named NBT Tag used to store a single 8 byte double precision
  /// floating point number.
  // ignore: constant_identifier_names
  TAG_DOUBLE,

  /// A named NBT Tag used to store a list of unnamed single bytes.
  // ignore: constant_identifier_names
  TAG_BYTE_ARRAY,

  /// A named NBT Tag used to store a single String.
  // ignore: constant_identifier_names
  TAG_STRING,

  /// A named NBT Tag used to store a List of unnamed NBT Tags, all of which
  /// are from the same type.
  // ignore: constant_identifier_names
  TAG_LIST,

  /// A named NBT Tag used to store a List of named NBT Tags of any type.
  // ignore: constant_identifier_names
  TAG_COMPOUND,

  /// A named NBT Tag used to store a list of unnamed big endian signed 4 byte integers.
  // ignore: constant_identifier_names
  TAG_INT_ARRAY,

  /// A named NBT Tag used to store a list of unnamed big endian signed 8 byte long integers.
  // ignore: constant_identifier_names
  TAG_LONG_ARRAY,
}

/// Extension on [NbtTagType] to give each enum value some functions.
extension NbtTagFunctions on NbtTagType {
  /// Gets a string representation of this tag.
  /// The default toString() cannot be overriden by extensions and
  /// returns "NbtTagType.TAG_END", instead of "TAG_END" or "TAG_End",
  /// which is shorter and more helpful in the end.
  String asString() {
    switch (this) {
      case NbtTagType.TAG_END:
        return 'TAG_End';
      case NbtTagType.TAG_BYTE:
        return 'TAG_Byte';
      case NbtTagType.TAG_SHORT:
        return 'TAG_Short';
      case NbtTagType.TAG_INT:
        return 'TAG_Int';
      case NbtTagType.TAG_LONG:
        return 'TAG_Long';
      case NbtTagType.TAG_FLOAT:
        return 'TAG_Float';
      case NbtTagType.TAG_DOUBLE:
        return 'TAG_Double';
      case NbtTagType.TAG_BYTE_ARRAY:
        return 'TAG_Byte_Array';
      case NbtTagType.TAG_STRING:
        return 'TAG_String';
      case NbtTagType.TAG_LIST:
        return 'TAG_List';
      case NbtTagType.TAG_COMPOUND:
        return 'TAG_Compound';
      case NbtTagType.TAG_INT_ARRAY:
        return 'TAG_Int_Array';
      case NbtTagType.TAG_LONG_ARRAY:
        return 'TAG_Long_Array';
      default:
        return '';
    }
  }
}
