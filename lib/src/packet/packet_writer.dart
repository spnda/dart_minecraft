import 'dart:typed_data';

import '../utilities/readers/_byte_writer.dart';
import 'packet_compression.dart';
import 'packet_writer_stub.dart' if (dart.library.io) 'packet_writer_io.dart';
import 'packets/server_packet.dart';

/// Writes various different server packets into binary.
abstract class PacketWriter extends ByteWriter<bool> {
  PacketWriter() {
    bytesBuilder = BytesBuilder(copy: true);
    allocate();
  }

  /// Create a new packet writer.
  ///
  /// Throws [UnsupportedError] if 'dart:io' does not
  /// exist.
  factory PacketWriter.create() => createWriter();

  /// Write a single server packet. This includes writing the
  /// length and packet id.
  Uint8List writePacket(ServerPacket packet,
      {PacketCompression compression = PacketCompression.none});

  /// Write a UTF8 encoded String with it's length
  /// prefixed as a variable length long integer.
  @override
  void writeString(String? value);
}
