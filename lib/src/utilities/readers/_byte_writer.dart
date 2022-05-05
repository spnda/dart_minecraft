import 'dart:convert';

import 'dart:typed_data';

abstract class ByteWriter<T> {
  static const megaByte = 1048576;

  int writePosition = 0;

  late BytesBuilder bytesBuilder;

  late ByteData writeByteData;

  /// The endianness to use when writing the data.
  Endian _endianness = Endian.big;

  /// Allocate a new [ByteData] with 1Megabyte of data.
  void allocate() {
    // 1048576 Uint8 = 1048576 Bytes = 1MB
    writeByteData = ByteData(megaByte);
  }

  /// Flush the data inside of [_curByteData] into the [_bytesBuilder] and
  /// allocate a new 1MB of data to [_curByteData].
  void flush(int offset) {
    if (writePosition + offset >= writeByteData.lengthInBytes - 1) {
      /// We take the sublist because otherwise, we would be writing the whole 1MB of this
      /// chunk into the [BytesBuilder] and that would be wasting a lot of space and invalidate
      /// the file.
      bytesBuilder
          .add(writeByteData.buffer.asUint8List().sublist(0, writePosition));
      allocate();
      writePosition = 0;
    }
  }

  /// Flush and re-allocate new bytes, while
  /// saving the old bytes and returning them.
  Uint8List get getBytes {
    flush(ByteWriter.megaByte);
    var bytes = bytesBuilder.toBytes();
    allocate();
    return bytes;
  }

  set setEndianness(Endian endian) {
    _endianness = endian;
  }

  /// Write a single byte.
  void writeByte(int value, {bool signed = false}) {
    flush(1);
    signed
        ? writeByteData.setInt8(writePosition++, value)
        : writeByteData.setUint8(writePosition++, value);
  }

  /// Write a single 2 byte short.
  void writeShort(int value, {bool signed = false}) {
    flush(2);
    signed
        ? writeByteData.setInt16(writePosition, value, _endianness)
        : writeByteData.setUint16(writePosition, value, _endianness);
    writePosition += 2;
  }

  /// Write a single 4 byte integer.
  void writeInt(int value, {bool signed = false}) {
    flush(4);
    signed
        ? writeByteData.setInt32(writePosition, value, _endianness)
        : writeByteData.setUint32(writePosition, value, _endianness);
    writePosition += 4;
  }

  /// Write a single 8 byte long.
  void writeLong(int value, {bool signed = false}) {
    flush(8);
    signed
        ? writeByteData.setInt64(writePosition, value, _endianness)
        : writeByteData.setUint64(writePosition, value, _endianness);
    writePosition += 8;
  }

  /// Write a single 8 byte variable length long.
  void writeVarLong(int value, {bool signed = false}) {
    if (signed || value < 0) {
      if (value < 0) {
        return writeVarLong(-2 * value - 1, signed: false);
      } else {
        return writeVarLong(2 * value, signed: false);
      }
    }
    while (true) {
      final byte = 0x7F & value;
      final nextValue = value >> 7;
      if (nextValue == 0) {
        writeByte(byte, signed: false);
        return;
      }
      writeByte(0x80 | byte, signed: false);
      value = nextValue;
    }
  }

  /// Write a single 4 byte single precision floating point number.
  void writeFloat(double value) {
    flush(4);
    writeByteData.setFloat32(writePosition, value, _endianness);
    writePosition += 4;
  }

  /// Write a single 8 byte double precision floating point number.
  void writeDouble(double value) {
    flush(8);
    writeByteData.setFloat64(writePosition, value, _endianness);
    writePosition += 8;
  }

  void writeBytes(List<int> bytes) {
    for (final val in bytes) {
      writeByte(val);
    }
  }

  /// Write a modified UTF-8 String. This includes writing its length
  /// as a single short integer.
  void writeString(String? value) {
    if (value == null || value == 'None') {
      writeShort(0, signed: false);
      return;
    }
    final string = utf8.encode(value);
    writeShort(string.length, signed: false);
    for (final val in string) {
      writeByte(val, signed: false);
    }
  }
}
