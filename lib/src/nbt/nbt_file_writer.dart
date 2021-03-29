import 'dart:io';
import 'dart:typed_data';

import '../utilities/readers/_byte_writer.dart';

import 'nbt_compression.dart';
import 'tags/nbt_compound.dart';
import 'tags/nbt_tag.dart';

/// A NBT file writer to write various [NbtTag] to a binary file.
class NbtFileWriter extends ByteWriter<bool> {
  final File _file;

  NbtCompound? _root;

  NbtCompression nbtCompression;

  /// Create a new NbtFileWriter with [_root] as the main
  /// node to use for writing.
  NbtFileWriter(this._file, {this.nbtCompression = NbtCompression.none}) {
    if (!_file.existsSync()) {
      _file.createSync();
    }
    bytesBuilder = BytesBuilder(copy: true);
    allocate();
  }

  /// Begin writing [_root] to the given [file]. If [file] does not exist,
  /// it will be created.
  Future<bool> write(NbtCompound data, {File? file}) async {
    _root ??= data;
    file ??= _file;

    // Write tags
    _root?.writeTag(this, withName: true, withType: true);

    flush(ByteWriter.megaByte);

    final builtBytes = bytesBuilder.toBytes();

    final bytes = compress(builtBytes, nbtCompression);

    file.writeAsBytesSync(bytes);
    return true;
  }

  /// Compress the given [bytes] with given [nbtCompression].
  List<int> compress(Uint8List bytes, NbtCompression nbtCompression) {
    switch (nbtCompression) {
      case NbtCompression.gzip:
        return gzip.encode(bytes);
      case NbtCompression.zlib:
        return zlib.encode(bytes);
      case NbtCompression.none:
      case NbtCompression.unknown:
      default:
        return bytes;
    }
  }
}
