import 'dart:convert';
import 'dart:io';

import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:test/test.dart';

void main() async {
  final testData =
      json.decode(File('./test/test_data.json').readAsStringSync());
  final username = testData['username'];
  final password = testData['password'];
  final uuid = testData['uuid'];

  test('API should return UUID for username', () async {
    var tuuid = (await Mojang.getUuid(username)).second;
    expect(tuuid, equals(uuid));
  });

  test('API should return a list of pairs with the sites status.', () async {
    final status = await Mojang.checkStatus();
    expect(status.minecraft, isA<MojangSiteStatus>());
  });

  test('API should return link to the skin of given player.', () async {
    final profile = await Mojang.getProfile(uuid);
    final skin = profile.textures.getSkinUrl();
    expect(skin, testData['skin_texture']);
  });

  test('Gets Minecraft sale statistics', () async {
    final statistics = await Mojang.getStatistics([
      MinecraftStatisticsItem.minecraftItemsSold,
      MinecraftStatisticsItem.minecraftPrepaidCardsRedeemed
    ]);
    expect(statistics.salesLast24h, isNotNull);
  });

  test('Gets Minecraft Dungeons sale statistics', () async {
    final statistics =
        await Mojang.getStatistics([MinecraftStatisticsItem.dungeonsItemsSold]);
    expect(statistics.salesLast24h, isNotNull);
  });

  test('API should return a list of names', () async {
    final nameHistory = await Mojang.getNameHistory(uuid);
    expect(nameHistory.first.name, equals(testData['firstUsername']));
    expect(nameHistory.last.name, equals(username));
  });

  test('Get list of blocked servers', () async {
    final servers = await Mojang.getBlockedServers();
    expect(servers, isNotEmpty);

    expect(servers.where((server) => server.address != null), isNotEmpty);
  });

  group('Yggdrasil Tests', () {
    test('refresh test', () async {
      try {
        var user = await Yggdrasil.authenticate(username, password);
        await Yggdrasil.refresh(user);
      } on AuthException catch (e) {
        print(e.message);

        /// We'll just manually make the test fail.
        expect(null, isNotNull);
      }
    });
  });
}
