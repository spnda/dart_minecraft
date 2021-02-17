import 'dart:io';
import 'package:dart_minecraft/src/nbt/nbt_file_reader.dart';
import 'package:path/path.dart' as path;

import 'tags/nbt_compound.dart';

/// Represents a NBT file.
class NbtFile {
  /// The filename of this .nbt file.
  String fileName;

  /// The file in the current system.
  File _file;

  /// The [NbtFileReader] of this file.
  NbtFileReader _nbtFileReader;

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
    return _nbtFileReader.beginRead();
  }

  /// The root node of this file.
  NbtCompound get root => _nbtFileReader?.root;
}
