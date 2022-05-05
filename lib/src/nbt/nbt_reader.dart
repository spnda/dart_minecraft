import 'dart:typed_data';

import '../exceptions/nbt_file_read_exception.dart';
import '../utilities/readers/_byte_reader.dart';
import 'file/nbt_file.dart' if (dart.library.io) 'file/nbt_file_io.dart';
import 'nbt_compression.dart';
import 'tags/nbt_compound.dart';
import 'tags/nbt_tag.dart';

class NbtReader extends ByteReader<bool> {
  NbtCompression nbtCompression = NbtCompression.none;

  NbtCompound? root;

  NbtReader(Uint8List list) {
    data = list;
    nbtCompression = _detectCompression();
    if (nbtCompression != NbtCompression.none) {
      data = nbtCompression.decompressData(data!);
    }
    readByteData = data!.buffer.asByteData();
  }

  /// Reads the file at [path] in bytes and constructs a new reader
  /// with that data. This method only works on native platforms,
  /// so every platform that includes support for 'dart:io'.
  ///
  /// Throws a [FileSystemException] if the file could not be found.
  factory NbtReader.fromFile(String path) => NbtReader(fromFile(path));

  /// Reads the NBT data from the byte list.
  /// Throws [NbtFileReadException] if an issue occured.
  NbtCompound read() {
    try {
      root = NbtTag.readNewTag(this, null, withName: true) as NbtCompound;
    } on Exception catch (e) {
      if (e is NbtFileReadException) rethrow;
      throw NbtFileReadException('Failed to read file.');
    }
    if (root == null) throw NbtFileReadException('Failed to read file');
    return root!;
  }

  /// Tries to detect the compression, whether the data was
  /// compressed with GZIP, ZLIB or wasn't compressed at all.
  NbtCompression _detectCompression() {
    final int firstByte;
    try {
      firstByte = data!.first;
    } on Error {
      throw NbtFileReadException('Could not read from file.');
    }
    switch (firstByte) {
      case -1:
        throw NbtFileReadException('File is invalid or empty.');
      case 0x0A:
        // The file begins with a NBTCompound and is therefore not compressed.
        return NbtCompression.none;
      case 0x1F:
        // GZip detection number
        return NbtCompression.gzip;
      case 0x78:
        // ZLib header
        return NbtCompression.zlib;
      default:
        return NbtCompression.unknown;
    }
  }

  Endian getContentEndian() {
    return Endian.big;
  }
}
