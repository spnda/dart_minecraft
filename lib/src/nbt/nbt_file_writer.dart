import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'nbt_compression.dart';
import 'tags/nbt_compound.dart';
import 'tags/nbt_tag.dart';

/// A NBT file writer to write various [NbtTag] to a binary file.
class NbtFileWriter {
  NbtCompound _root;

  /// The current read position inside of [_byteData].
  int _writePosition = 0;

  BytesBuilder bytesBuilder;

  NbtFileWriter(this._root);

  Future<bool> beginWrite(File file, {NbtCompression nbtCompression = NbtCompression.none}) async {
    if (!file.existsSync()) {
      file.createSync();
    }
    bytesBuilder = BytesBuilder();
    
    // Write tags
    _root.writeTag(this, withName: true);

    final bytes = compress(bytesBuilder.toBytes(), nbtCompression);

    file.writeAsBytesSync(bytes);
    return true;
  }

  Uint8List compress(Uint8List bytes, NbtCompression nbtCompression) {
    switch (nbtCompression) {
      case NbtCompression.gzip: return gzip.encode(bytes);
      case NbtCompression.zlib: return zlib.encode(bytes);
      case NbtCompression.none:
      case NbtCompression.unknown:
      default:
        return bytes;
    }
  }

  void writeByte(int value, {bool signed = false}) {
    final byteData = ByteData(1);
    signed ? byteData.setInt8(0, value) : byteData.setUint8(0, value);
    bytesBuilder.add(byteData.buffer.asUint8List());
  }

  void writeShort(int value, {bool signed = false}) {
    final byteData = ByteData(2);
    signed ? byteData.setInt16(0, value) : byteData.setUint16(0, value);
    bytesBuilder.add(byteData.buffer.asUint8List());
  }

  void writeInt(int value, {bool signed = false}) {
    final byteData = ByteData(4);
    signed ? byteData.setInt32(0, value) : byteData.setUint32(0, value);
    bytesBuilder.add(byteData.buffer.asUint8List());
  }

  void writeLong(int value, {bool signed = false}) {
    final byteData = ByteData(8);
    signed ? byteData.setInt64(0, value) : byteData.setUint64(0, value);
    bytesBuilder.add(byteData.buffer.asUint8List());
  }

  void writeFloat(double value) {
    final byteData = ByteData(4);
    byteData.setFloat32(0, value);
    bytesBuilder.add(byteData.buffer.asUint8List());
  }

  void writeDouble(double value) {
    final byteData = ByteData(8);
    byteData.setFloat64(0, value);
    bytesBuilder.add(byteData.buffer.asUint8List());
  }

  void writeString(String value) {
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
