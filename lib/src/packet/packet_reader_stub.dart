import 'dart:typed_data';

import 'packet_reader.dart';
import 'packets/server_packet.dart';

/// Implemented in `io_packet_reader.dart`.
PacketReader fromList(List<int> list) =>
    throw UnsupportedError('dart:io required to read/write packets.');

/// Implemented in `io_packet_reader.dart`.
Future<ServerPacket> fromStream(Stream<Uint8List> stream) async =>
    throw UnsupportedError('dart:io required to read/write packets.');
