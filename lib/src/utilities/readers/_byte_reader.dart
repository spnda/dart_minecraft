import 'dart:convert';
import 'dart:typed_data';

import '../pair.dart';

abstract class ByteReader<T> {
  /// List of bytes to read.
  Uint8List? data;

  /// [_data] represented as a [ByteData] to ease with the
  /// reading of various integers and floats.
  ByteData? readByteData;

  /// The current read position inside of [_byteData];
  int readPosition = 0;

  Endian _endianness = Endian.big;

  set setEndianness(Endian endian) {
    _endianness = endian;
  }

  void resetPosition() {
    readPosition = 0;
  }

  void reset(Uint8List list) {
    readPosition = 0;
    data = list;
    readByteData = data!.buffer.asByteData();
  }

  /// Reads a single byte at [readPosition].
  int readByte({bool signed = false}) {
    return signed
        ? readByteData!.getInt8(readPosition++)
        : readByteData!.getUint8(readPosition++);
  }

  /// Reads a 2 byte short starting at [readPosition].
  int readShort({bool signed = false}) {
    final value = signed
        ? readByteData!.getInt16(readPosition, _endianness)
        : readByteData!.getUint16(readPosition, _endianness);
    readPosition += 2;
    return value;
  }

  /// Reads a 4 byte integer starting at [readPosition].
  int readInt({bool signed = false}) {
    final value = signed
        ? readByteData!.getInt32(readPosition, _endianness)
        : readByteData!.getUint32(readPosition, _endianness);
    readPosition += 4;
    return value;
  }

  /// Reads a 8 byte integer starting at [readPosition].
  int readLong({bool signed = false}) {
    final value = signed
        ? readByteData!.getInt64(readPosition, _endianness)
        : readByteData!.getUint64(readPosition, _endianness);
    readPosition += 8;
    return value;
  }

  /// Reads a 8 byte variable length long starting at [readPosition].
  /// The format of this long will be as to LEB128, or better what
  /// Minecraft uses.
  /// Returns a Pair, in which the first integer is the read value
  /// and the second the length of the var-integer in bytes.
  Pair<int, int> readVarLong({bool signed = false}) {
    var index = readPosition;
    var value = 0;
    for (var i = 0; i < 64; i += 7) {
      final byte = readByteData!.getUint8(index++);
      value |= (0x7F & byte) << i;
      if (0x80 & byte == 0) break;
    }
    var length = index - readPosition;
    readPosition = index;

    if (signed) {
      final rem = value % 2;
      return Pair(rem == 0 ? value ~/ 2 : (value ~/ -2) - 1, length);
    } else {
      return Pair(value, length);
    }
  }

  /// Reads a 4 byte float starting at [readPosition].
  double readFloat({bool signed = false}) {
    final value = readByteData!.getFloat32(readPosition, _endianness);
    readPosition += 4;
    return value;
  }

  /// Reads a 8 byte double starting at [readPosition].
  double readDouble({bool signed = false}) {
    final value = readByteData!.getFloat64(readPosition, _endianness);
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
