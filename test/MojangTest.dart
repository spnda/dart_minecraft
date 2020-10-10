import 'dart:convert';
import 'dart:io';

import 'package:dart_minecraft/src/Mojang/Status/MojangStatus.dart';
import 'package:test/test.dart';
import 'package:dart_minecraft/minecraft.dart';

void main() {
  final test_data = json.decode(File('./test_data.json').readAsStringSync());
  final username = test_data['username'];
  final password = test_data['password'];
  final uuid = test_data['uuid'];
  
  test('API should return UUID for username', () async {
    var tuuid = (await Mojang.getUuid(username)).getSecond;
    expect(tuuid, equals(uuid));
  });

  test('API should return a list of pairs with the sites status.', () async {
    final status = await Mojang.checkStatus();
    expect(status.minecraft, equals(MojangSiteStatus.Unavailable));
  });

  test('API should return link to the skin of given player.', () async {
    final profile = await Mojang.getProfile(uuid);
    final skin = profile.getTextures.getSkinUrl();
    expect(skin, test_data['skin_texture']);
  });

  test('Gets Minecraft sale statistics', () async {
    final statistics = await Mojang.getStatistics([MinecraftStatisticsItem.MinecraftItemsSold, MinecraftStatisticsItem.MinecraftPrepaidCardsRedeemed]);
    print(statistics);
  });

  test('Gets Minecraft Dungeons sale statistics', () async {
    final statistics = await Mojang.getStatistics([MinecraftStatisticsItem.DungeonsItemsSold]);
    print(statistics);
  });

  test('refresh test', () async {
    var user = await Mojang.authenticate(username, password);
    await Mojang.refresh(user);
    print(user.accessToken);
  });

  test('API should return a list of names', () async {
    final nameHistory = await Mojang.getNameHistory(uuid);
    nameHistory.forEach((Name f) => print(f));
  });
}
