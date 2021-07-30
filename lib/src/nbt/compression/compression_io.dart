import 'dart:io' as io;
import 'dart:typed_data';

import '../nbt_compression.dart';

List<int> compress(NbtCompression compression, Uint8List data) {
  switch (compression) {
    case NbtCompression.gzip:
      return io.gzip.encode(data);
    case NbtCompression.zlib:
      return io.zlib.encode(data);
    case NbtCompression.none:
    case NbtCompression.unknown:
    default:
      return data;
  }
}

Uint8List decompress(NbtCompression compression, Uint8List data) {
  switch (compression) {
    case NbtCompression.gzip:
      return Uint8List.fromList(io.gzip.decode(data));
    case NbtCompression.zlib:
      return Uint8List.fromList(io.zlib.decode(data));
    case NbtCompression.unknown:
      throw Exception('Invalid NBT File.');
    case NbtCompression.none:
    default:
      // Don't need to do anything for no compression.
      return data;
  }
}
