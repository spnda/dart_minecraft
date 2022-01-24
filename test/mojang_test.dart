import 'dart:convert';
import 'dart:io';

import 'package:dart_minecraft/dart_minecraft.dart';
import 'package:dart_minecraft/src/mojang_api.dart';
import 'package:dart_minecraft/src/mojang/mojang_account.dart';
import 'package:dart_minecraft/src/yggdrasil_api.dart';
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
      var temp_uuid = (await getUuid(username)).second;
      expect(temp_uuid, equals(uuid));
    } on ArgumentError catch (e) {
      print(e);
    }
  });

  test('API should return link to the skin of given player.', () async {
    try {
      final profile = await getProfile(uuid);
      final skins = profile.getSkins;
      expect(skins, isNotEmpty);
      expect(skins.first.url, testData['skin_texture']);
    } on ArgumentError catch (e) {
      print(e);
    }
  });

  test('Gets Minecraft sale statistics', () async {
    final statistics = await getStatistics([
      MinecraftStatisticsItem.minecraftItemsSold,
      MinecraftStatisticsItem.minecraftPrepaidCardsRedeemed
    ]);
    expect(statistics.salesLast24h, isNotNull);
  });

  test('Gets Minecraft Dungeons sale statistics', () async {
    final statistics =
        await getStatistics([MinecraftStatisticsItem.dungeonsItemsSold]);
    expect(statistics.salesLast24h, isNotNull);
  });

  test('API should return a list of names', () async {
    try {
      final nameHistory = await getNameHistory(uuid);
      expect(nameHistory.first.name, equals(testData['first_username']));
      expect(nameHistory.last.name, equals(username));
    } on ArgumentError catch (e) {
      print(e);
    }
  });

  test('Get list of blocked servers', () async {
    final servers = await getBlockedServers();
    expect(servers, isNotEmpty);

    expect(servers.where((server) => server.address != null), isNotEmpty);
  });

  group('Yggdrasil Tests:', () {
    MojangAccount? user;

    test('refresh test', () async {
      try {
        user = await authenticate(testData['email'], testData['password']);
        // await refresh(user!);
      } on AuthException catch (e) {
        print(e);
      }
    });

    test('Test if the player can migrate', () async {
      try {
        if (user == null) return;
        var migrate = await canMigrate(user!.accessToken);
        print('The player can migrate: $migrate');
      } on Error catch (e) {
        print(e);
      }
    });

    test('Test if access token is valid', () async {
      try {
        if (user == null) return;
        var valid =
            await validate(user!.accessToken, clientToken: user!.clientToken);
        expect(valid, isTrue);
      } on Error catch (e) {
        print(e);
      }
    });

    test('Get user profile with authentication', () async {
      try {
        if (user == null) return;
        final profile = await getCurrentProfile(user!.accessToken);
        final skins = profile.getSkins;
        expect(skins, isNotEmpty);
        expect(skins.first.url, testData['skin_texture']);
      } on Error catch (e) {
        print(e);
      }
    });

    var needed = false;
    test('Check if security questions are required.', () async {
      if (user == null) return;
      needed = await areSecurityChallengesNeeded(user!.accessToken);
      expect(needed, isNotNull);
    });

    test('Get security questions and answer them', () async {
      if (user == null || !needed) return;
      final challenges = await getSecurityChallenges(user!.accessToken);
      expect(challenges, isList);
      expect(challenges, hasLength(3)); // There should always be 3 challenges.
    });
  });
}
