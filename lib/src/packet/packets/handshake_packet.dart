import '../packet_reader.dart';
import '../packet_writer.dart';
import 'server_packet.dart';

/// Handshake packet to ping or login to the server.
class HandshakePacket extends ServerPacket {
  /// The protocol version of the client. When pinging, -1 should
  /// be used.
  final int protocolVersion;

  /// Hostname or IP. The Notchian server does not use this information.
  /// Redirects and SRV records should be considered.
  final String serverAddress;

  /// Default is 25565. The Notchian server does not use this information.
  /// Max value is 65535.
  final int serverPort;

  /// Should be 1 for status, but could also be 2 for login.
  final int nextState;

  HandshakePacket({
    required this.serverAddress,
    this.protocolVersion = -1,
    this.serverPort = 25565,
    this.nextState = 1,
  });

  @override
  int get getID => 0;

  @override
  Future<bool> read(PacketReader reader) async {
    return true;
  }

  @override
  void writePacket(PacketWriter writer) {
    writer.writeVarLong(protocolVersion, signed: true);
    writer.writeString(serverAddress);
    writer.writeShort(serverPort, signed: false);
    writer.writeVarLong(nextState, signed: false);
  }

  @override
  ServerPacket clone() {
    throw UnsupportedError('clone() is not supported on serverbound packets.');
  }
}
