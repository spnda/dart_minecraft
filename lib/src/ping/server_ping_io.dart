import 'dart:io';

import '../exceptions/ping_exception.dart';
import '../packet/packet_reader.dart';
import '../packet/packet_writer.dart';
import '../packet/packets/handshake_packet.dart';
import '../packet/packets/ping_packet.dart';
import '../packet/packets/pong_packet.dart';
import '../packet/packets/request_packet.dart';
import '../packet/packets/response_packet.dart';
import '../packet/packets/server_packet.dart';

/// Write a single package
void _writePacket(Socket socket, ServerPacket packet) async {
  final packetEncoded = PacketWriter().writePacket(packet);
  socket.add(packetEncoded);
}

int _now() => DateTime.now().millisecondsSinceEpoch;

Future<ResponsePacket?> pingUri(String serverUri) async {
  final split = serverUri.split(':');
  if (split.length == 2) {
    return ping(split[0], port: int.parse(split[1]));
  } else {
    return ping(split[0]);
  }
}

/// Ping a single server. [port] will default to 25565 as that is the
/// default Minecraft server port. This method is for post 1.6 servers.
Future<ResponsePacket?> ping(String serverUri,
    {int port = 25565, Duration timeout = const Duration(seconds: 30)}) async {
  try {
    // Register the packets we will require
    ServerPacket.registerClientboundPacket(ResponsePacket());
    ServerPacket.registerClientboundPacket(PongPacket());

    final socket = await Socket.connect(serverUri, port, timeout: timeout);
    final stream = socket.asBroadcastStream();

    _writePacket(socket, HandshakePacket(serverAddress: serverUri));
    _writePacket(socket, RequestPacket());

    final responsePacket =
        await PacketReader.readPacketFromStream(stream) as ResponsePacket;

    final pingPacket = PingPacket(_now());
    _writePacket(socket, pingPacket);
    final pongPacket =
        await PacketReader.readPacketFromStream(stream) as PongPacket;

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
