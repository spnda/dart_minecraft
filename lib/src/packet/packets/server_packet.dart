import 'dart:collection';

import '../packet_reader.dart';
import '../packet_writer.dart';

/// The basis of each and every packet for post 1.6
/// servers.
abstract class ServerPacket {
  /// Static Map to keep track of all existing [ServerPacket]s.
  static final HashMap<int, ServerPacket> _clientbound_packets = HashMap();

  /// The ID of this packet
  int get getID;

  /// Write a single packet into given [writer]'s
  /// byte data.
  void writePacket(PacketWriter writer);

  /// Read a single packet from given [reader]'s
  /// byte data.
  void read(PacketReader reader);

  /// Clone this packet and create a new instance of it.
  ServerPacket clone();

  /// Read a single packet by ID.
  static ServerPacket? readPacket(int id, PacketReader reader) {
    return _clientbound_packets[id]?.clone()?..read(reader);
  }

  /// Register a new clientbound packet. If a clientbound packet
  /// with given ID is already registered, [packet] will be
  /// ignored.
  static void registerClientboundPacket(ServerPacket packet) {
    _clientbound_packets.putIfAbsent(packet.getID, () => packet);
  }
}
