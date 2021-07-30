import 'dart:typed_data';

import '../nbt_compression.dart';

/// Compress the given [bytes].
List<int> compress(NbtCompression compression, Uint8List data) => data;

// Decompresses the given [bytes].
Uint8List decompress(NbtCompression compression, Uint8List data) => data;
