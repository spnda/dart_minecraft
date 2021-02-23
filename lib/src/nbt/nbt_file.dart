import 'dart:io';

import 'package:path/path.dart';

import 'nbt_compression.dart';
import 'nbt_file_reader.dart';
import 'nbt_file_writer.dart';
import 'tags/nbt_compound.dart';

/// Represents a NBT file.
class NbtFile {
  /// The filename of this .nbt file.
  String fileName;

  /// The file in the current system.
  final File _file;

  /// The [NbtFileReader] of this file.
  NbtFileReader _nbtFileReader;

  /// The [NbtFileWriter] of this file.
  NbtFileWriter _nbtFileWriter;

  /// The root node of this file.
  NbtCompound? root;

  /// Create a [NbtFile] from a String path.
  /// May throw [FileSystemException].
  NbtFile.fromPath(String path) : 
    _file = File(path), 
    fileName = basename(path),
    _nbtFileReader = NbtFileReader(),
    _nbtFileWriter = NbtFileWriter();

  /// Creates a [NbtFile] from a [File].
  /// May throw [FileSystemException].
  NbtFile.fromFile(this._file) : 
    fileName = '',
    _nbtFileReader = NbtFileReader(),
    _nbtFileWriter = NbtFileWriter() {
    fileName = basename(_file.path);
  }

  /// Read the file and read all data to the [root] node.
  Future<bool> readFile({File? file}) async {
    if (file == null) file = _file;
    _nbtFileReader = NbtFileReader();
    final val = await _nbtFileReader.beginRead(file);
    // Save a copy of the read root NbtCompound.
    root = _nbtFileReader.root;
    return val;
  }

  /// Write the [root] node into [_file] or given [file] with [nbtCompression].
  /// This will override any data stored in that file.
  Future<bool> writeFile({File? file, NbtCompression nbtCompression = NbtCompression.none}) async {
    _nbtFileWriter = NbtFileWriter();
    if (file == null) file = _file;
    if (root == null) throw Exception('Cannot write file, root is not defined.');
    return _nbtFileWriter.beginWrite(root!, file, nbtCompression: nbtCompression);
  }

  /// Get the compression from the last read file. If no file has been read,
  /// this value will be null.
  NbtCompression? get compression => _nbtFileReader.nbtCompression;
}
