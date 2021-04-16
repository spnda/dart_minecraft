import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../utilities/readers/_byte_writer.dart';
import 'packet_compression.dart';
import 'packets/server_packet.dart';

/// Writes various different server packets into binary.
class PacketWriter extends ByteWriter<bool> {
  PacketWriter() {
    bytesBuilder = BytesBuilder(copy: true);
    allocate();
  }

  /// Write a single server packet. This includes writing the
  /// length and packet id.
  Uint8List writePacket(ServerPacket packet,
      {PacketCompression compression = PacketCompression.none}) {
    if (compression == PacketCompression.zlib) writeVarLong(packet.getID);
    packet.writePacket(this);
    var bytes = getBytes;
    bytesBuilder.clear(); // Clear our previous builder.

    switch (compression) {
      case PacketCompression.zlib:

        /// With ZLIB compression, packets have 4 fields:
        /// - Packet Length (VarInt), includes length of data length, packet ID and data.
        /// - Data Length (VarInt)
        /// - Packet ID (VarInt, compressed)
        /// - Data (Byte Array, compressed)
        final dataLength = bytes.lengthInBytes;
        bytes = zlib.encode(bytes) as Uint8List;

        /// Bytes already includes the packet id.

        /// Write the data length as a var-long and then flush
        /// the bytes to get the single var-long in bytes.
        writeVarLong(dataLength);
        final dataLengthInBytes = getBytes;
        bytesBuilder.clear();

        writeVarLong(dataLengthInBytes.lengthInBytes + bytes.length);
        writeBytes(dataLengthInBytes);
        writeBytes(bytes);

        /// Write the previously created packet ID and data.
        return bytesBuilder.toBytes();

      case PacketCompression.none:
      default:

        /// Without compression, packets have only 3 fields:
        /// - Length (VarInt)
        /// - Packet ID (VarInt)
        /// - Data (Byte Array)
        writeVarLong(bytes.length + 1, signed: false);
        writeVarLong(packet.getID, signed: false);
        writeBytes(bytes);
        flush(ByteWriter.megaByte);
        return bytesBuilder.toBytes();
    }
  }

  /// Write a UTF8 encoded String with it's length
  /// prefixed as a variable length long integer.
  @override
  void writeString(String? value) {
    if (value == null) return;
    final stringData = utf8.encode(value);
    writeVarLong(stringData.length, signed: false);
    writeBytes(stringData);
  }
}
