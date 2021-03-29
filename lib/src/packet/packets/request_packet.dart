import '../packet_reader.dart';
import '../packet_writer.dart';
import 'server_packet.dart';

/// Packet without any fields indicating that the
/// client is requesting basic server information.
class RequestPacket extends ServerPacket {
  RequestPacket() : super(0);

  @override
  Future<bool> read(PacketReader reader) async {
    return true;
  }

  @override
  void writePacket(PacketWriter writer) {}
}
