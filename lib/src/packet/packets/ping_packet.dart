import '../packet_reader.dart';
import '../packet_writer.dart';
import 'server_packet.dart';

class PingPacket extends ServerPacket {
  final int value;

  PingPacket(this.value);

  @override
  int get getID => 1;

  @override
  void read(PacketReader reader) {}

  @override
  void writePacket(PacketWriter writer) {
    writer.writeLong(value, signed: true);
  }

  @override
  ServerPacket clone() {
    throw UnsupportedError('clone() is not supported on serverbound packets.');
  }
}
