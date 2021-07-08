import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'packet_compression.dart';
import 'packet_reader.dart';
import 'packets/server_packet.dart';

PacketReader fromList(List<int> list) => IoPacketReader.fromList(list);

Future<ServerPacket> fromStream(Stream<Uint8List> stream) async =>
    IoPacketReader.fromStream(stream);

/// Reads different server packets from binary into objects.
class IoPacketReader extends PacketReader {
  IoPacketReader(Uint8List data) {
    this.data = data;
    readByteData = data.buffer.asByteData();
  }

  /// Create a [PacketReader] from a integer [List].
  /// If [list] is not a [Uint8List], we will create
  /// one from given [list].
  factory IoPacketReader.fromList(List<int> list) {
    if (list is Uint8List) {
      return IoPacketReader(list);
    }
    return IoPacketReader(Uint8List.fromList(list));
  }

  /// Read a single packet from a Stream. This Stream will most likely
  /// from a [Socket], though any Stream will work. This will read
  /// multiple chunks from the Stream, until the initially sent packet
  /// size is met.
  static Future<ServerPacket> fromStream(Stream<Uint8List> stream) async {
    final buffer = <int>[];

    /// As a single packet can be bigger than a single
    /// chunk of data that is emitted, we'll add to
    /// our [buffer] object and check if the length is
    /// now as big as the packet's [size] says.
    await for (final data in stream) {
      if (data.isEmpty) continue;

      buffer.addAll(data);

      final packetReader = IoPacketReader.fromList(buffer);
      final size = packetReader.readVarLong(signed: false).first;

      if (buffer.length >= size) break;
    }

    final packetReader = IoPacketReader.fromList(buffer);
    return packetReader.readPacket();
  }

  @override
  ServerPacket readPacket(
      {PacketCompression compression = PacketCompression.none}) {
    Uint8List? payload;
    int? id;
    switch (compression) {
      case PacketCompression.zlib:
        final packetSize = readVarLong(signed: false).first;
        final dataSize = readVarLong(signed: false);

        // Decompress the packet data.
        var size = packetSize - dataSize.second;
        final compressedPayload =
            Uint8List(size); // This includes the packet ID.
        for (var i = 0; i < size - 1; i++) {
          compressedPayload[i] = readByte(signed: false);
        }
        payload = zlib.decode(compressedPayload) as Uint8List;

        // Reset the read data with our new payload to extract the ID.
        reset(payload);
        id = readVarLong(signed: false).first;
        payload = payload.sublist(readPosition);
        break;

      case PacketCompression.none:
      default:
        final size = readVarLong(signed: false).first;
        id = readVarLong(signed: false).first;

        payload = Uint8List(size - 1);
        for (var i = 0; i < size - 1; i++) {
          payload[i] = readByte(signed: false);
        }
        break;
    }

    reset(payload);

    final packet = ServerPacket.readPacket(id, this);
    if (packet == null) {
      throw Exception('Encountered unexpected packet with ID $id');
    }
    return packet;
  }

  /// Read a string where the length is encoded as a var long.
  @override
  String readString() {
    final length = readVarLong(signed: false).first;
    final str = utf8.decode(Uint8List.view(
      readByteData!.buffer,
      readByteData!.offsetInBytes + readPosition,
      length,
    ));
    return str;
  }
}
