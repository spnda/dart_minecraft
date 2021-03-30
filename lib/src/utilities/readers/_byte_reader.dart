import 'dart:convert';
import 'dart:typed_data';

abstract class ByteReader<T> {
  /// List of bytes to read.
  Uint8List? data;

  /// [_data] represented as a [ByteData] to ease with the
  /// reading of various integers and floats.
  ByteData? readByteData;

  /// The current read position inside of [_byteData];
  int readPosition = 0;

  /// Reads a single byte at [readPosition].
  int readByte({bool signed = false}) {
    return signed
        ? readByteData!.getInt8(readPosition++)
        : readByteData!.getUint8(readPosition++);
  }

  /// Reads a 2 byte short starting at [readPosition].
  int readShort({bool signed = false}) {
    final value = signed
        ? readByteData!.getInt16(readPosition)
        : readByteData!.getUint16(readPosition);
    readPosition += 2;
    return value;
  }

  /// Reads a 4 byte integer starting at [readPosition].
  int readInt({bool signed = false}) {
    final value = signed
        ? readByteData!.getInt32(readPosition)
        : readByteData!.getUint32(readPosition);
    readPosition += 4;
    return value;
  }

  /// Reads a 8 byte integer starting at [readPosition].
  int readLong({bool signed = false, Endian endian = Endian.big}) {
    final value = signed
        ? readByteData!.getInt64(readPosition, endian)
        : readByteData!.getUint64(readPosition, endian);
    readPosition += 8;
    return value;
  }

  /// Reads a 8 byte variable length long starting at [readPosition].
  /// The format of this long will be as to LEB128, or better what
  /// Minecraft uses.
  int readVarLong({bool signed = false}) {
    var index = readPosition;
    final value = () {
      var result = 0;
      for (var i = 0; i < 64; i += 7) {
        final byte = readByteData!.getUint8(index++);
        result |= (0x7F & byte) << i;
        if (0x80 & byte == 0) break;
      }
      readPosition = index;
      return result;
    }.call();
    if (signed) {
      final rem = value % 2;
      return rem == 0 ? value ~/ 2 : (value ~/ -2) - 1;
    } else {
      return value;
    }
  }

  /// Reads a 4 byte float starting at [readPosition].
  double readFloat({bool signed = false}) {
    final value = readByteData!.getFloat32(readPosition);
    readPosition += 4;
    return value;
  }

  /// Reads a 8 byte double starting at [readPosition].
  double readDouble({bool signed = false}) {
    final value = readByteData!.getFloat64(readPosition);
    readPosition += 8;
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
      string.add(readByte(signed: false));
    }
    return utf8.decode(string);
  }
}
