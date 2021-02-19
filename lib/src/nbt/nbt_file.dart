import 'dart:io';

import 'package:dart_minecraft/src/nbt/nbt_file_writer.dart';
import 'package:path/path.dart' as path;

import 'nbt_compression.dart';
import 'nbt_file_reader.dart';
import 'tags/nbt_compound.dart';

/// Represents a NBT file.
class NbtFile {
  /// The filename of this .nbt file.
  String fileName;

  /// The file in the current system.
  File _file;

  /// The [NbtFileReader] of this file.
  NbtFileReader _nbtFileReader;

  /// The [NbtFileWriter] of this file.
  NbtFileWriter _nbtFileWriter;

  /// Create a [NbtFile] from a String path.
  /// May throw [FileSystemException].
  NbtFile.fromPath(String path) {
    _file = File(path);
  }

  /// Creates a [NbtFile] from a [File].
  /// May throw [FileSystemException].
  NbtFile.fromFile(this._file) {
    fileName = path.basename(_file.path);
  }

  /// Read the file and read all data to the [root] node.
  Future<bool> readFile() async {
    _nbtFileReader = NbtFileReader(_file.openRead());
    await _nbtFileReader.init();
    final val = await _nbtFileReader.beginRead();
    // Save a copy of the read root NbtCompound.
    root = _nbtFileReader.root;
    return val;
  }

  Future<bool> writeFile({File file, NbtCompression nbtCompression = NbtCompression.none}) async {
    _nbtFileWriter = NbtFileWriter(root);
    if (file == null) file = _file;
    return _nbtFileWriter.beginWrite(file, nbtCompression: nbtCompression);
  }

  /// The root node of this file.
  NbtCompound root;

  /// Get the compression from the last read file. If no file has been read,
  /// this value will be null.
  NbtCompression get compression => _nbtFileReader?.nbtCompression;
}
