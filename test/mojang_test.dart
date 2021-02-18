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
    var tuuid = (await Mojang.getUuid(username)).getSecond;
    expect(tuuid, equals(uuid));
  });

  test('API should return a list of pairs with the sites status.', () async {
    final status = await Mojang.checkStatus();
    expect(status.minecraft, equals(MojangSiteStatus.unavailable));
  });

  test('API should return link to the skin of given player.', () async {
    final profile = await Mojang.getProfile(uuid);
    final skin = profile.getTextures.getSkinUrl();
    expect(skin, testData['skin_texture']);
  });

  test('Gets Minecraft sale statistics', () async {
    final statistics = await Mojang.getStatistics([
      MinecraftStatisticsItem.minecraftItemsSold,
      MinecraftStatisticsItem.minecraftPrepaidCardsRedeemed
    ]);
    print(statistics);
  });

  test('Gets Minecraft Dungeons sale statistics', () async {
    final statistics =
        await Mojang.getStatistics([MinecraftStatisticsItem.dungeonsItemsSold]);
    print(statistics);
  });

  test('refresh test', () async {
    var user = await Mojang.authenticate(username, password);
    await Mojang.refresh(user);
    print(user.accessToken);
  });

  test('API should return a list of names', () async {
    final nameHistory = await Mojang.getNameHistory(uuid);
    nameHistory.forEach(print);
  });
}
