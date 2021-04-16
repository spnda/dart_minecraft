import '../packet_reader.dart';
import '../packet_writer.dart';
import 'server_packet.dart';

class PongPacket extends ServerPacket {
  int? value;

  PongPacket();

  @override
  int get getID => 1;

  @override
  void read(PacketReader reader) {
    value = reader.readLong(signed: true);
  }

  @override
  void writePacket(PacketWriter writer) {}

  @override
  ServerPacket clone() {
    return PongPacket();
  }
}
