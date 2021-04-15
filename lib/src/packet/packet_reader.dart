import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../utilities/readers/_byte_reader.dart';
import 'packet_compression.dart';
import 'packets/pong_packet.dart';
import 'packets/response_packet.dart';
import 'packets/server_packet.dart';

/// Reads different server packets from binary into objects.
class PacketReader extends ByteReader<bool> {
  PacketReader(Uint8List data) {
    this.data = data;
    readByteData = data.buffer.asByteData();
  }

  /// Create a [PacketReader] from a integer [List].
  /// If [list] is not a [Uint8List], we will create
  /// one from given [list].
  factory PacketReader.fromList(List<int> list) {
    if (list is Uint8List) {
      return PacketReader(list);
    }
    return PacketReader(Uint8List.fromList(list));
  }

  ServerPacket readPacket({PacketCompression compression = PacketCompression.none}) {
    Uint8List? payload;
    int? id;
    switch (compression) {
      case PacketCompression.zlib:
        final packetSize = readVarLong(signed: false).first;
        final dataSize = readVarLong(signed: false);

        // Decompress the packet data.
        var size = packetSize - dataSize.second;
        final compressedPayload = Uint8List(size); // This includes the packet ID.
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

    switch (id) {
      case 0:
        return ResponsePacket()..read(this);
      case 1:
        return PongPacket()..read(this);
      default:
        throw Exception('Encountered unexpected packet with ID $id');
    }
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
