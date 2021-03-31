import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../utilities/readers/_byte_writer.dart';
import 'packets/server_packet.dart';

/// Writes various different server packets into binary.
class PacketWriter extends ByteWriter<bool> {
  PacketWriter() {
    bytesBuilder = BytesBuilder(copy: true);
    allocate();
  }

  /// Write a single server packet. This includes writing the
  /// length and packet id.
  Uint8List writePacket(ServerPacket packet) {
    packet.writePacket(this);
    flush(ByteWriter.megaByte); // Flush all data written from the packet
    final bytes = bytesBuilder.toBytes();
    allocate(); // Re-allocate 1MB for new writing.
    bytesBuilder.clear(); // Clear our previous builder.

    writeVarLong(bytes.length + 1, signed: false);
    writeVarLong(packet.id, signed: false);
    writeBytes(bytes);
    flush(ByteWriter.megaByte);
    return bytesBuilder.toBytes();
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
