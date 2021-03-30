import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:test/test.dart';

void main() {
  const uri = 'mc.hypixel.net';

  test('Test if ping picks up server.', () async {
    final serverInfo = await ping(uri);
    expect(serverInfo, isNotNull);
    if (serverInfo!.response == null) return;
    print('Players online on $uri:');
    print(
        '${serverInfo.response!.players.online} / ${serverInfo.response!.players.max}');
    print('Latency: ${serverInfo.ping}');
  });
}
