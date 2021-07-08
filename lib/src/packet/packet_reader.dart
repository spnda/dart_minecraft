import 'dart:typed_data';

import '../utilities/readers/_byte_reader.dart';
import 'packet_compression.dart';
import 'packet_reader_stub.dart' if (dart.library.io) 'packet_reader_io.dart';
import 'packets/server_packet.dart';

/// Reads different server packets from binary into objects.
abstract class PacketReader extends ByteReader<bool> {
  PacketReader();

  /// Create a [PacketReader] from a integer [List].
  /// If [list] is not a [Uint8List], we will create
  /// one from given [list].
  factory PacketReader.fromList(List<int> list) => fromList(list);

  /// Read a single packet from a Stream. This Stream will most likely
  /// from a [Socket], though any Stream will work. This will read
  /// multiple chunks from the Stream, until the initially sent packet
  /// size is met.
  static Future<ServerPacket> readPacketFromStream(Stream<Uint8List> stream) =>
      fromStream(stream);

  ServerPacket readPacket(
      {PacketCompression compression = PacketCompression.none});

  /// Read a string where the length is encoded as a var long.
  @override
  String readString();
}
