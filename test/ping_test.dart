import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:test/test.dart';

void main() {
  const uri = 'mc.hypixel.net';

  test('Test if ping picks up server.', () async {
    try {
      final serverInfo = await ping(uri);
      expect(serverInfo, isNotNull);
      if (serverInfo!.response == null) return;

      print('Modt: ${serverInfo.response!.description.description}');
      expect(serverInfo.response!.description.description, isNotNull);
      // A bit hacky, cannot expect for the MODT to never change
      expect(serverInfo.response!.description.description, contains('Hypixel'));

      print('Players online on $uri:');
      print(
          '${serverInfo.response!.players.online} / ${serverInfo.response!.players.max}');
      print('Latency: ${serverInfo.ping}');
    } on PingException catch (e) {
      print('Failed to ping the server.');
      print(e);
    }
  });
}
