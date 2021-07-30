import 'dart:typed_data';

import 'compression/compression.dart'
    if (dart.library.io) 'compression/compression_io.dart';

/// The compression of a [NbtFile].
/// Implementation of detecting the compression can be found
/// at [NbtFileReader#detectCompression].
enum NbtCompression {
  /// The file does not have any compression.
  none,

  /// Gzip compressed files usually start with 1F.
  gzip,

  /// Zlib compressed files usually start with 78.
  zlib,

  /// There was an error reading the compression.
  unknown,
}

extension CompressionFunctionExtension on NbtCompression {
  /// Compress the given [data]. On JS platforms, this
  /// does nothing, as it requires converters from 'dart:io'.
  List<int> compressData(Uint8List data) => compress(this, data);

  /// Decompress the given [data]. On JS platforms, this
  /// does nothing, as it requires converters from 'dart:io'.
  Uint8List decompressData(Uint8List data) => decompress(this, data);
}
