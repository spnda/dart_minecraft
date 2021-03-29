import 'dart:convert';
import 'dart:io';

import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:dart_minecraft/src/mojang/mojang_account.dart';
import 'package:test/test.dart';

void main() async {
  final testDataFile = File('./test/test_data.json');
  if (!testDataFile.existsSync()) {
    /// "uuid", "username", "skin_texture" and "first_username" are required to test the API.
    ///
    /// If Yggradsil authentication API should be tested, please also add "email" and "password".
    /// Note: This will log you out of your minecraft launcher.
    throw Exception(
        'test_data.json is required to run this test. Required fields are "username", "uuid", "skin_texture", "first_username".');
  }
  final testData = json.decode(testDataFile.readAsStringSync());
  final username = testData['username'];
  final uuid = testData['uuid'];

  test('API should return UUID for username', () async {
    try {
      var temp_uuid = (await Mojang.getUuid(username)).second;
      expect(temp_uuid, equals(uuid));
    } on ArgumentError catch (e) {
      print(e);
    }
  });

  test('API should return a list of pairs with the sites status.', () async {
    final status = await Mojang.checkStatus();
    expect(status.minecraft, isA<MojangSiteStatus>());
  });

  test('API should return link to the skin of given player.', () async {
    try {
      final profile = await Mojang.getProfile(uuid);
      final skin = profile.textures.getSkinUrl();
      expect(skin, testData['skin_texture']);
    } on ArgumentError catch (e) {
      print(e);
    }
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
    try {
      final nameHistory = await Mojang.getNameHistory(uuid);
      expect(nameHistory.first.name, equals(testData['first_username']));
      expect(nameHistory.last.name, equals(username));
    } on ArgumentError catch (e) {
      print(e);
    }
  });

  test('Get list of blocked servers', () async {
    final servers = await Mojang.getBlockedServers();
    expect(servers, isNotEmpty);

    expect(servers.where((server) => server.address != null), isNotEmpty);
  });

  group('Yggdrasil Tests', () {
    MojangAccount? user;

    test('refresh test', () async {
      try {
        user = await Yggdrasil.authenticate(
            testData['email'], testData['password']);
        await Yggdrasil.refresh(user!);
      } on AuthException catch (e) {
        print(e);
      } on Error catch (e) {
        print(e);
      }
    });

    test('Test if access token is valid', () async {
      try {
        if (user == null) return;
        var valid = await Yggdrasil.validate(user!.accessToken,
            clientToken: user!.clientToken);
        expect(valid, isTrue);
      } on Error catch (e) {
        print(e);
      }
    });
  });
}
