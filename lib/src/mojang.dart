import 'dart:async';
import 'dart:io';

import 'exceptions/auth_exception.dart';
import 'minecraft/blocked_server.dart';
import 'minecraft/minecraft_statistics.dart';
import 'mojang/mojang_status.dart';
import 'mojang/name.dart';
import 'mojang/profile.dart';
import 'utilities/pair.dart';
import 'utilities/web_util.dart';

/// Mojang API specific functionality.
///
/// Mojang account, authentication and status APIs.
class Mojang {
  static const String _statusApi = 'https://status.mojang.com/';
  static const String _mojangApi = 'https://api.mojang.com/';
  static const String _sessionApi = 'https://sessionserver.mojang.com/';
  static const String _minecraftServices = 'https://api.minecraftservices.com/';

  /// Returns the Mojang and Minecraft API and website status
  static Future<MojangStatus> checkStatus() async {
    final response = await WebUtil.get(_statusApi, 'check');
    final list = await WebUtil.getJsonFromResponse(response);
    if (list is! List) {
      throw Exception(
          'Content returned from the server is in an unexpected format.');
    } else {
      return MojangStatus.fromJson(list);
    }
  }

  /// Returns the UUID for player [username].
  ///
  /// A [timestamp] can be passed to retrieve the UUID for the player with [username]
  /// at that point in time.
  static Future<Pair<String, String>> getUuid(String username,
      {DateTime? timestamp}) async {
    final time =
        timestamp == null ? '' : '?at=${timestamp.millisecondsSinceEpoch}';
    final response = await WebUtil.get(
        _mojangApi, 'users/profiles/minecraft/$username$time');
    final map = await WebUtil.getJsonFromResponse(response);
    if (map == null || map is! Map) {
      throw Exception(
          'Content returned from the server is in an unexpected format.');
    }
    if (map['error'] != null) {
      if (response.statusCode == 404) {
        throw ArgumentError.value(
            username, 'username', 'No user was found for given username');
      }
      throw Exception(map['errorMessage']);
    }
    return Pair<String, String>(username, map['id']);
  }

  /// Returns a List of player UUIDs by a List of player names.
  ///
  /// Usernames are not case sensitive and ones which are invalid or not found are omitted.
  static Future<List<Pair<String, String>>> getUuids(
      List<String> usernames) async {
    final response = await WebUtil.post(_mojangApi, 'profiles/minecraft',
        usernames, {HttpHeaders.contentTypeHeader: 'application/json'});
    final list = await WebUtil.getJsonFromResponse(response);
    if (list is! List<Map>) {
      throw Exception(
          'Content returned from the server is in an unexpected format.');
    } else {
      return list
          .map<Pair<String, String>>(
              (v) => Pair<String, String>(v['name'], v['id']))
          .toList();
    }
  }

  /// Returns the name history for the account with [uuid].
  static Future<List<Name>> getNameHistory(String uuid) async {
    final response = await WebUtil.get(_mojangApi, 'user/profiles/$uuid/names');
    final list = await WebUtil.getJsonFromResponse(response);
    if (list == null || list is! List || response.statusCode == 404) {
      throw ArgumentError.value(uuid, 'uuid', 'User for given UUID could not be found');
    }
    return Future.value(list.map((dynamic v) => Name.fromJson(v)).toList());
  }

  /// Returns the user profile including skin/cape information.
  ///
  /// Using [getProfile(uuid).getTextures] both skin and cape textures can be obtained.
  static Future<Profile> getProfile(String uuid) async {
    final response =
        await WebUtil.get(_sessionApi, 'session/minecraft/profile/$uuid');
    final map = await WebUtil.getJsonFromResponse(response);
    if (map == null || map is! Map<String, dynamic> || response.statusCode == 404) {
      throw ArgumentError.value(uuid, 'uuid', 'User for given UUID could not be found');
    }
    return Profile.fromJson(map);
  }

  /// Changes the Mojang account name to [newName].
  static Future<bool> changeName(
      String uuid, String newName, String accessToken, String password) async {
    final body = <String, String>{'name': newName, 'password': password};
    final headers = <String, String>{
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    final response = await WebUtil.post(
        _minecraftServices, 'user/profile/$uuid/name', body, headers);
    if (response.statusCode != 200) {
      /// https://wiki.vg/Mojang_API#Change_Name for details on the
      /// possibly errors.
      switch (response.statusCode) {
        case 400:
          throw ArgumentError(
              'Name is invalid, longer than 16 characters or contains characters other than (a-zA-Z0-9_)');
        case 401:
          throw AuthException(AuthException.invalidCredentialsMessage);
        case 403:
          throw Exception(
              'Name is unavailable (Either taken or has not become available).');
        case 500:
          throw Exception('Timed out.');
        default:
          throw Exception('Unexpected error occurred.');
      }
    } else {
      return true;
    }
  }

  /// Reserves the [newName] for this Mojang Account.
  // TODO: Improved return type including error message. Or just throw an error?
  static Future<bool> reserveName(String newName, String accessToken) async {
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
      'Origin': 'https://checkout.minecraft.net',
    };
    final response = await WebUtil.put(
        _mojangApi, 'user/profile/agent/minecraft/name/$newName', {}, headers);
    if (response.statusCode != 204) {
      return false;
      /* switch (response.statusCode) {
        case 400: throw Exception('Name is unavailable.');
        case 401: throw Exception('Unauthorized.');
        case 403: throw Exception('Forbidden.');
        case 504: throw Exception('Timed out.');
        default: throw Exception('Unexpected error occurred.');
      } */
    } else {
      return true;
    }
  }

  /// Reset's the player's skin.
  static Future<void> resetSkin(String uuid, String accessToken) async {
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    };
    await WebUtil.delete(_mojangApi, 'user/profile/$uuid/skin', headers);
  }

  /// Change the skin with the texture of the skin at [skinUrl].
  static Future<bool> changeSkin(Uri skinUrl, String accessToken,
      [SkinModel skinModel = SkinModel.classic]) async {
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    };
    final data = {
      'variant': skinModel.toString().replaceFirst('SkinModel', ''),
      'url': skinUrl,
    };
    final response = await WebUtil.post(
        _minecraftServices, 'minecraft/profile/skins', data, headers);
    switch (response.statusCode) {
      case 401:
        throw AuthException(AuthException.invalidCredentialsMessage);
      default:
        {
          print(response);
          return true;
        }
    }
  }

  /// Get's Minecraft: Java Edition, Minecraft Dungeons, Cobalt and Scrolls purchase statistics.
  ///
  /// Returns total statistics for ALL games included. To get individual statistics, call this
  /// function for each MinecraftStatisticsItem or each game.
  static Future<MinecraftStatistics> getStatistics(
      List<MinecraftStatisticsItem> items) async {
    final payload = {
      'metricKeys': [
        for (MinecraftStatisticsItem item in items) item.name,
      ]
    };
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    final response =
        await WebUtil.post(_mojangApi, 'orders/statistics', payload, headers);
    final data = await WebUtil.getJsonFromResponse(response);
    return MinecraftStatistics.fromJson(data);
  }

  /// Returns a list of blocked servers.
  static Future<List<BlockedServer>> getBlockedServers() async {
    final response = await WebUtil.get(_sessionApi, 'blockedservers');
    final data = (await WebUtil.getResponseBody(response)).split('\n');
    final ret = <BlockedServer>[];
    for (final server in data) {
      ret.add(BlockedServer.parse(server));
    }
    return ret;
  }
}
