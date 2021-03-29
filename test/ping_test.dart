import 'package:dart_minecraft/src/server_ping.dart';
import 'package:test/test.dart';

void main() {
  test('Test if ping picks up server.', () async {
    const uri = 'mc.hypixel.net';

    final pingResult = await ping(uri);
    expect(pingResult, isNotNull);
    if (pingResult!.response == null) return;
    print('Players online on $uri:');
    print(
        '${pingResult.response!.players.online} / ${pingResult.response!.players.max}');
  });
}
