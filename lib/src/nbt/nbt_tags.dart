/// Different tags for each Nbt Tag that exists.
enum NbtTagType {
  TAG_END,
  TAG_BYTE,
  TAG_SHORT,
  TAG_INT,
  TAG_LONG,
  TAG_FLOAT,
  TAG_DOUBLE,
  TAG_BYTE_ARRAY,
  TAG_STRING,
  TAG_LIST,
  TAG_COMPOUND,
  TAG_INT_ARRAY,
  TAG_LONG_ARRAY,
}

extension NbtTagFunctions on NbtTagType {
  /// Gets a string representation of this tag.
  /// The default toString() cannot be overriden by extensions and
  /// returns "NbtTagType.TAG_END", instead of "TAG_END" or "TAG_End",
  /// which is shorter and more helpful in the end.
  String asString() {
    switch (this) {
      case NbtTagType.TAG_END: return 'TAG_End';
      case NbtTagType.TAG_BYTE: return 'TAG_Byte';
      case NbtTagType.TAG_SHORT: return 'TAG_Short';
      case NbtTagType.TAG_INT: return 'TAG_Int';
      case NbtTagType.TAG_LONG: return 'TAG_Long';
      case NbtTagType.TAG_FLOAT: return 'TAG_Float';
      case NbtTagType.TAG_DOUBLE: return 'TAG_Double';
      case NbtTagType.TAG_BYTE_ARRAY: return 'TAG_Byte_Array';
      case NbtTagType.TAG_STRING: return 'TAG_String';
      case NbtTagType.TAG_LIST: return 'TAG_List';
      case NbtTagType.TAG_COMPOUND: return 'TAG_Compound';
      case NbtTagType.TAG_INT_ARRAY: return 'TAG_Int_Array';
      case NbtTagType.TAG_LONG_ARRAY: return 'TAG_Long_Array';
      default: return '';
    } 
  }
}
