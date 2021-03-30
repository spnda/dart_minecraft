import 'dart:io';
import 'dart:typed_data';

import 'exceptions/ping_exception.dart';
import 'packet/packet_reader.dart';
import 'packet/packet_writer.dart';
import 'packet/packets/handshake_packet.dart';
import 'packet/packets/ping_packet.dart';
import 'packet/packets/pong_packet.dart';
import 'packet/packets/request_packet.dart';
import 'packet/packets/response_packet.dart';
import 'packet/packets/server_packet.dart';

/// Write a single package
void _writePacket(Socket socket, ServerPacket packet) async {
  final packetEncoded = PacketWriter().writePacket(packet);
  socket.add(packetEncoded);
}

Future<ServerPacket> _readPacket(Stream<Uint8List> stream) async {
  final buffer = <int>[];

  /// As a single packet can be bigger than a single
  /// chunk of data that is emitted, we'll add to
  /// our [buffer] object and check if the length is
  /// now as big as the packet's [size] says.
  await for (final data in stream) {
    if (data.isEmpty) continue;

    buffer.addAll(data);

    final packetReader = PacketReader.fromList(buffer);
    final size = packetReader.readVarLong(signed: false);

    if (buffer.length >= size) break;
  }

  final packetReader = PacketReader.fromList(buffer);
  return packetReader.readPacket();
}

int _now() => DateTime.now().millisecondsSinceEpoch;

/// Ping a single server. [port] will default to 25565 as that is the
/// default Minecraft server port. This method is for post 1.6 servers.
Future<ResponsePacket?> ping(String serverUri, {int port = 25565}) async {
  try {
    final socket = await Socket.connect(serverUri, port);
    final stream = socket.asBroadcastStream();

    _writePacket(socket, HandshakePacket(serverAddress: serverUri));
    _writePacket(socket, RequestPacket());

    final responsePacket = await _readPacket(stream) as ResponsePacket;

    final pingPacket = PingPacket(_now());
    _writePacket(socket, pingPacket);
    final pongPacket = await _readPacket(stream) as PongPacket;

    await socket.close();
    var ping = pongPacket.value! - pingPacket.value;

    /// If the ping is 0, we'll instead use the time it took
    /// for the server to respond and the packet returning back home.
    if (ping <= 0) {
      ping = _now() - pingPacket.value;
    }
    return responsePacket..ping = ping;
  } on SocketException {
    throw PingException('Could not connect to $serverUri');
  } on RangeError {
    throw PingException('Server sent unexpected data');
  }
}
