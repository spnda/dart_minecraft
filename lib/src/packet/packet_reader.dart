import 'dart:convert';
import 'dart:typed_data';

import '../utilities/readers/_byte_reader.dart';
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

  ServerPacket readPacket() {
    final size = readVarLong(signed: false);
    final id = readVarLong(signed: false);

    final payload = Uint8List(size - 1);
    for (var i = 0; i < size - 1; i++) {
      payload[i] = readByte(signed: false);
    }

    readPosition = 0;
    data = payload;
    readByteData = data!.buffer.asByteData();

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
    final length = readVarLong(signed: false);
    final str = utf8.decode(Uint8List.view(
      readByteData!.buffer,
      readByteData!.offsetInBytes + readPosition,
      length,
    ));
    return str;
  }
}
