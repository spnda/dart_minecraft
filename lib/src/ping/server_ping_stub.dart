import '../packet/packets/response_packet.dart';

Future<ResponsePacket?> pingUri(String serverUri) async {
  throw UnsupportedError('dart:io is required to ping servers.');
}

/// Ping a single server. [port] will default to 25565 as that is the
/// default Minecraft server port. This method is for post 1.6 servers.
Future<ResponsePacket?> ping(String serverUri,
    {int port = 25565, Duration timeout = const Duration(seconds: 30)}) async {
  throw UnsupportedError('dart:io is required to ping servers.');
}
