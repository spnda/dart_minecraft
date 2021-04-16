import 'dart:convert';

import '../packet_reader.dart';
import '../packet_writer.dart';
import 'server_packet.dart';

/// The response of the server regarding a [RequestPacket].
/// This packet contains various information like icon, description,
/// current server count and the server's version and protocol version.
class ResponsePacket extends ServerPacket {
  /// The time in milliseconds that it took for the server to receive
  /// the first request packet. If the server returns the same timestamp,
  /// this will instead be the time it took for the server to respond to
  /// the request.
  int? ping;

  ServerResponse? response;

  ResponsePacket();

  @override
  int get getID => 0;

  @override
  Future<bool> read(PacketReader reader) async {
    final content = reader.readString();
    response = ServerResponse.fromJson(json.decode(content));
    return true;
  }

  @override
  void writePacket(PacketWriter writer) {}

  @override
  ServerPacket clone() {
    return ResponsePacket();
  }
}

class ServerResponse {
  late final ServerVersion version;
  late final ServerPlayers players;
  late final ServerDescription description;
  late final String favicon;

  ServerResponse({required this.favicon});

  ServerResponse.fromJson(Map<String, dynamic> json) {
    version = ServerVersion.fromJson(json['version']);
    players = ServerPlayers.fromJson(json['players']);
    description = json['description'] is String
        ? ServerDescription.fromString(json['description'])
        : ServerDescription.fromJson(json['description']);
    favicon = (json['favicon'] as String? ?? '').replaceAll('\n', '');
  }

  List<int> get getImageBytes {
    return base64.decode(favicon.split('data:image/png;base64,')[1]);
  }
}

class ServerVersion {
  final String name;
  final int protocol;

  ServerVersion.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        protocol = json['protocol'];
}

class ServerPlayers {
  late final int max;
  late final int online;
  late final List<ServerPlayer> sample;

  ServerPlayers.fromJson(Map<String, dynamic> json)
      : max = json['max'],
        online = json['online'],
        sample = (json['sample'] as List? ?? [])
            .map((s) => ServerPlayer.fromJson(s))
            .toList(growable: false);
}

class ServerDescription {
  final String description;

  ServerDescription.fromJson(Map<String, dynamic> json)
      : description = json['description'] ?? '';

  ServerDescription.fromString(String description) : description = description;
}

class ServerPlayer {
  final String name;
  final String id;

  ServerPlayer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'];
}
