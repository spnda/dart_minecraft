import 'dart:io';
import 'dart:typed_data';

import '../exceptions/nbt_file_read_exception.dart';
import '../utilities/readers/_byte_reader.dart';
import 'nbt_compression.dart';
import 'tags/nbt_compound.dart';
import 'tags/nbt_tag.dart';

/// A file reader to read nbt data from a binary file.
class NbtFileReader extends ByteReader<bool> {
  /// The file that gets read from.
  final File _file;

  /// The root compound of this file.
  NbtCompound? root;

  /// The compression of [_file].
  NbtCompression? nbtCompression;

  /// Creates a [NbtFileReader].
  NbtFileReader(this._file) {
    data = _file.readAsBytesSync();
    nbtCompression = _detectCompression();
    data = decompressData(data!);
    readByteData = data!.buffer.asByteData();
  }

  /// Begin reading the NBT data.
  Future<bool> read() async {
    try {
      root = NbtTag.readNewTag(this, null, withName: true) as NbtCompound;
    } on Exception {
      throw NbtFileReadException('Could not read file.');
    } finally {
      return true;
    }
  }

  Uint8List decompressData(Uint8List data) {
    switch (nbtCompression) {
      case NbtCompression.gzip:
        return Uint8List.fromList(gzip.decode(data));
      case NbtCompression.zlib:
        return Uint8List.fromList(zlib.decode(data));
      case NbtCompression.unknown:
        throw Exception('Invalid NBT File.');
      case NbtCompression.none:
      default:
        // Don't need to do anything for no compression.
        return data;
    }
  }

  /// Tries to detect the compression, whether this file was
  /// compressed with GZIP, ZLIB or wasn't compressed at all.
  NbtCompression _detectCompression() {
    final firstByte;
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
}
