import 'dart:io';

import 'exceptions/ping_exception.dart';
import 'packet/packet_reader.dart';
import 'packet/packet_writer.dart';
import 'packet/packets/handshake_packet.dart';
import 'packet/packets/request_packet.dart';
import 'packet/packets/response_packet.dart';
import 'packet/packets/server_packet.dart';

/// Ping a single server. [port] will default to 25565 as that is the
/// default Minecraft server port. This method is for post 1.6 servers.
Future<ResponsePacket?> ping(String serverUri, {int port = 25565}) async {
  try {
    final socket = await Socket.connect(serverUri, port);
    final stream = socket.asBroadcastStream();

    /// Write a single package
    void writePacket(ServerPacket packet) async {
      final packetEncoded = PacketWriter().writePacket(packet);
      socket.add(packetEncoded);
    }

    /// Read a packet from the socket's [stream].
    Future<ServerPacket> readPacket() async {
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

    writePacket(HandshakePacket(serverAddress: serverUri));
    writePacket(RequestPacket());

    return (await readPacket() as ResponsePacket);
  } on SocketException {
    throw PingException('Could not connect to $serverUri');
  } on RangeError {
    throw PingException('Server sent unexpected data');
  }
}
