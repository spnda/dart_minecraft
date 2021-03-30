import 'dart:io';

import 'package:path/path.dart';

import '../exceptions/nbt_file_read_exception.dart';
import '../exceptions/nbt_file_write_exception.dart';
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
  NbtFileReader? _nbtFileReader;

  /// The [NbtFileWriter] of this file.
  NbtFileWriter? _nbtFileWriter;

  /// The root node of this file.
  NbtCompound? root;

  /// Create a [NbtFile] from a String path.
  /// May throw [FileSystemException].
  NbtFile.fromPath(String path)
      : _file = File(path)..createSync(),
        fileName = basename(path);

  /// Creates a [NbtFile] from a [File].
  /// May throw [FileSystemException].
  NbtFile.fromFile(this._file)
      : fileName = '' {
    fileName = basename(_file.path);
  }

  /// Read the file and read all data to the [root] node.
  Future<bool> readFile() async {
    if (!_file.existsSync()) {
      throw NbtFileReadException('File does not exist.');
    }
    _nbtFileReader = NbtFileReader(_file);
    final val = await _nbtFileReader!.read();
    // Save a copy of the read root NbtCompound.
    root = _nbtFileReader!.root;
    return val;
  }

  /// Write the [root] node into [_file] or given [file] with [nbtCompression].
  /// This will override any data stored in that file.
  Future<bool> writeFile(
      {File? file, NbtCompression nbtCompression = NbtCompression.none}) async {
    file ??= _file;
    if (root == null) {
      throw NbtFileWriteException('Cannot write file, root is not defined.');
    }

    _nbtFileWriter = NbtFileWriter(file);
    _nbtFileWriter!.nbtCompression = nbtCompression;
    return _nbtFileWriter!.write(root!, file: file);
  }

  /// Get the compression from the last read file. If no file has been read,
  /// this value will be null.
  NbtCompression? get compression => _nbtFileReader?.nbtCompression;
}
