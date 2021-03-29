import '../packet_reader.dart';
import '../packet_writer.dart';

/// The basis of each and every packet for
/// post 1.6 servers.
abstract class ServerPacket {
  /// The ID of this packet.
  final int id;

  ServerPacket(this.id);

  /// Write a single packet into given [writer]'s
  /// byte data.
  void writePacket(PacketWriter writer);

  /// Read a single packet from given [reader]'s
  /// byte data.
  void read(PacketReader reader);
}
