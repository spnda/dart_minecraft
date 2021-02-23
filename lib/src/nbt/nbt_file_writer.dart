import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'nbt_compression.dart';
import 'tags/nbt_compound.dart';
import 'tags/nbt_tag.dart';

/// A NBT file writer to write various [NbtTag] to a binary file.
class NbtFileWriter {
  NbtCompound? _root;

  int _writePosition = 0;

  BytesBuilder? _bytesBuilder;

  ByteData? _curByteData;

  /// Create a new NbtFileWriter with [_root] as the main
  /// node to use for writing.
  NbtFileWriter();

  /// Begin writing [_root] to the given [file]. If [file] does not exist,
  /// it will be created.
  Future<bool> beginWrite(NbtCompound root, File file, {NbtCompression nbtCompression = NbtCompression.none}) async {
    if (_root == null) _root = root;
    if (!file.existsSync()) {
      file.createSync();
    }
    _bytesBuilder = BytesBuilder(copy: true);
    _allocate();
    
    // Write tags
    _root?.writeTag(this, withName: true, withType: true);

    _flush(1048576);

    final bytes = compress(_bytesBuilder!.toBytes(), nbtCompression);

    file.writeAsBytesSync(bytes);
    return true;
  }

  /// Compress the given [bytes] with given [nbtCompression].
  List<int> compress(Uint8List bytes, NbtCompression nbtCompression) {
    switch (nbtCompression) {
      case NbtCompression.gzip: return gzip.encode(bytes);
      case NbtCompression.zlib: return zlib.encode(bytes);
      case NbtCompression.none:
      case NbtCompression.unknown:
      default:
        return bytes;
    }
  }

  /// Allocate a new [ByteData] with 1Megabyte of data.
  void _allocate() {
    // 1048576 Uint8 = 1048576 Bytes = 1MB
    _curByteData = ByteData(1048576);
  }

  /// Flush the data inside of [_curByteData] into the [_bytesBuilder] and
  /// allocate a new 1MB of data to [_curByteData].
  void _flush(int offset) {
    if (_writePosition + offset >= _curByteData!.lengthInBytes - 1) {
      /// We take the sublist because otherwise, we would be writing the whole 1MB of this 
      /// chunk into the [BytesBuilder] and that would be wasting a lot of space and invalidate
      /// the file.
      _bytesBuilder!.add(_curByteData!.buffer.asUint8List().sublist(0, _writePosition));
      _allocate();
      _writePosition = 0;
    }
  }

  /// Write a single byte.
  void writeByte(int value, {bool signed = false}) {
    _flush(1);
    signed ? _curByteData!.setInt8(_writePosition++, value) : _curByteData!.setUint8(_writePosition++, value);
  }

  /// Write a single 2 byte short.
  void writeShort(int value, {bool signed = false, Endian endian = Endian.big}) {
    _flush(2);
    signed ? _curByteData!.setInt16(_writePosition, value, endian) : _curByteData!.setUint16(_writePosition, value, endian);
    _writePosition += 2;
  }

  /// Write a single 4 byte integer.
  void writeInt(int value, {bool signed = false, Endian endian = Endian.big}) {
    _flush(4);
    signed ? _curByteData!.setInt32(_writePosition, value, endian) : _curByteData!.setUint32(_writePosition, value, endian);
    _writePosition += 4;
  }

  /// Write a single 8 byte long.
  void writeLong(int value, {bool signed = false, Endian endian = Endian.big}) {
    _flush(8);
    signed ? _curByteData!.setInt64(_writePosition, value, endian) : _curByteData!.setUint64(_writePosition, value, endian);
    _writePosition += 8;
  }

   /// Write a single 4 byte single precision floating point number.
  void writeFloat(double value, {Endian endian = Endian.big}) {
    _flush(4);
    _curByteData!.setFloat32(_writePosition, value, endian);
    _writePosition += 4;
  }

  /// Write a single 8 byte double precision floating point number.
  void writeDouble(double value, {Endian endian = Endian.big}) {
    _flush(8);
    _curByteData!.setFloat64(_writePosition, value, endian);
    _writePosition += 8;
  }

  /// Write a modified UTF-8 String. This includes writing its length
  /// as a single short integer.
  void writeString(String? value) {
    if (value == null || value == 'None') {
      writeShort(0, signed: false);
      return;
    }
    writeShort(value.length, signed: false);
    final string = utf8.encode(value);
    for (final val in string) {
      writeByte(val, signed: false);
    }
  }
}
