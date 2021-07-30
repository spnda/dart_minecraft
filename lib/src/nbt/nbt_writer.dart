import 'dart:typed_data';

import '../utilities/readers/_byte_writer.dart';
import 'file/nbt_file.dart' if (dart.library.io) 'file/nbt_file_io.dart';
import 'nbt_compression.dart';
import 'tags/nbt_compound.dart';

/// A byte writer used to serialize NBT data into binary
/// files.
class NbtWriter extends ByteWriter<bool> {
  NbtCompound? _root;

  NbtCompression nbtCompression;

  /// Create a new NbtWriter.
  NbtWriter({this.nbtCompression = NbtCompression.none}) {
    bytesBuilder = BytesBuilder(copy: true);
    allocate();
  }

  /// Write the given [data] compound into a list of
  /// bytes. See [writeFile] on how to quickly write
  /// to a file.
  List<int> write(NbtCompound data) {
    _root ??= data;

    _root?.writeTag(this, withName: true, withType: true);

    flush(ByteWriter.megaByte);

    final builtBytes = bytesBuilder.toBytes();
    return nbtCompression.compressData(builtBytes);
  }

  /// Writes the given [data] compound to the file located
  /// at [path]. This method only works on native platforms,
  /// so every platform that includes support for 'dart:io'.
  ///
  /// Throws [FileSystemException] if [path] points to a
  /// invalid location.
  Future<void> writeFile(String path, NbtCompound data) async =>
      toFile(path, write(data));
}
