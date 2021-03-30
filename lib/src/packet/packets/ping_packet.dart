import '../packet_reader.dart';
import '../packet_writer.dart';
import 'server_packet.dart';

class PingPacket extends ServerPacket {
  final int value;

  PingPacket(this.value) : super(1);

  @override
  void read(PacketReader reader) {

  }

  @override
  void writePacket(PacketWriter writer) {
    writer.writeLong(value, signed: true);
  }
}
