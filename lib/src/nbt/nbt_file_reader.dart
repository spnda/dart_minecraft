import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'nbt_compression.dart';
import 'tags/nbt_compound.dart';
import 'tags/nbt_tag.dart';

/// A file reader to read nbt data from a binary file.
class NbtFileReader {
  /// The original file stream
  final Stream<List<int>> _fileStream;

  /// A list of bytes from the file
  Uint8List _data;

  /// [_data] represented as a [ByteData] to ease with the
  /// reading of various integers and floats.
  ByteData _byteData;

  /// The current read position inside of [_byteData].
  int _readPosition = 0;

  /// Wether this reader is initialized and [_byteData]
  /// has valid data.
  bool _initialized = false;

  /// The root compound of this file.
  NbtCompound _root;

  /// The compression of [_file].
  NbtCompression _nbtCompression;

  /// Creates a [NbtFileReader]. Given FileStream will be used 
  /// to get the bytes to read.
  NbtFileReader(this._fileStream);

  /// Get the root NbtCompound of this file.
  NbtCompound get root => _root;

  /// Initialize this reader.
  Future<bool> init() async {
    _initialized = await _getData();
    return _initialized;
  }

  /// Waits for all the values from [_fileStream] to resolve
  /// and adds them to [_data];
  Future<bool> _getData() async {
    final _temp = <int>[];
    await for (final list in _fileStream) {
      for (final chunk in list) {
        _temp.add(chunk);
      }
    }
    _data = Uint8List.fromList(_temp);
    return true;
  }

  /// Begin reading from the pre-
  /// 
  /// Throws [Exception] if [init] has not been called.
  Future<bool> beginRead() async {
    if (!_initialized) throw Exception('Not initialized. Please call init() before reading.');

    // First detect compression if any
    _nbtCompression = _detectCompression();

    switch (_nbtCompression) {
      case NbtCompression.gzip:
        _data = gzip.decode(_data);
        break;
      case NbtCompression.zlib:
        _data = zlib.decode(_data);
        break;
      case NbtCompression.unknown:
        throw Exception('Invalid NBT File.');
      case NbtCompression.none:
      default:
        // Don't need to do anything for no compression.
        break;
    }

    _byteData = _data.buffer.asByteData();

    _root = NbtTag.readTag(this, null);
    
    return true;
  }

  /// Reads a single byte at [readPosition].
  int readByte({bool signed = false}) {
    return signed ? _byteData.getInt8(_readPosition++) : _byteData.getUint8(_readPosition++);
  }

  /// Reads a 2 byte short starting at [readPosition].
  int readShort({bool signed = false}) {
    final value = signed ? _byteData.getInt16(_readPosition) : _byteData.getUint16(_readPosition);
    _readPosition += 2;
    return value;
  }

  /// Reads a 4 byte integer starting at [readPosition].
  int readInt({bool signed = false}) {
    final value = signed ? _byteData.getInt32(_readPosition) : _byteData.getUint32(_readPosition);
    _readPosition += 4;
    return value;
  }

  /// Reads a 8 byte integer starting at [readPosition].
  int readLong({bool signed = false}) {
    final value = signed ? _byteData.getInt64(_readPosition) : _byteData.getUint64(_readPosition);
    _readPosition += 8;
    return value;
  }

  /// Reads a 4 byte float starting at [readPosition].
  double readFloat({bool signed = false}) {
    final value = _byteData.getFloat32(_readPosition);
    _readPosition += 4;
    return value;
  }

  /// Reads a 8 byte double starting at [readPosition].
  double readDouble({bool signed = false}) {
    final value = _byteData.getFloat64(_readPosition);
    _readPosition += 8;
    return value;
  }

  /// Reads a string at [readPosition]. It will first read 
  /// a 2 byte short for the length, then reads length-amount
  /// of bytes and decodes them as UTF-8.
  String readString() {
    var length = readShort(signed: false);
    if (length == 0) return '';
    var string = <int>[];
    for (var i = 0; i < length; i++) {
      string.add(readByte());
    }
    return utf8.decode(string);
  }

  /// Tries to detect the compression, wether this file was
  /// compressed with GZIP, ZLIB or wasn't compressed at all.
  NbtCompression _detectCompression() {
    final firstByte = _data.first;
    switch (firstByte) {
      case -1: throw Exception('file is empty?');
      case 0x0A: {
        // The file begins with a NBTCompound and is therefore not compressed.
        return NbtCompression.none;
      }
      case 0x1F: { // GZip detection number
        return NbtCompression.gzip;
      }
      case 0x78: { // ZLib header
        return NbtCompression.zlib;
      }
      default: {
        return NbtCompression.unknown;
      }
    }
  }
}