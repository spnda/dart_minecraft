import 'dart:async';

import 'package:dart_minecraft/src/Minecraft/MinecraftStatistics.dart';
import 'package:dart_minecraft/src/Mojang/Name.dart';
import 'package:dart_minecraft/src/Mojang/Profile.dart';
import 'package:dart_minecraft/src/Mojang/Status/MojangStatus.dart';
import 'package:dart_minecraft/src/utilities/Pair.dart';
import 'package:dart_minecraft/src/utilities/WebUtil.dart';

/// Includes all Mojang specific functionality.
/// 
/// This includes account managing and status information.
class Mojang {
  static const String _statusApi  = 'https://status.mojang.com/';
  static const String _mojangApi  = 'https://api.mojang.com/';
  static const String _sessionApi = 'https://sessionserver.mojang.com/';

  /// Gets the API Status
  static Future<MojangStatus> checkStatus() async {
    final response = await WebUtil.get(_statusApi, 'check');
    final list = await WebUtil.getJsonFromResponse(response);
    if (!(list is List)) {
      throw Exception('Content returned from the server is in an unexpected format.');
    } else {
      return MojangStatus.fromJson(list);
    }
  }

  /// Returns the UUID for player `username`.
  /// 
  /// A `timestamp` can be passed to retrieve the UUID for the player with `username`
  /// at `timestamp`.
  static Future<Pair<String, String>> getUuid(String username, {DateTime timestamp}) async {
    final time = timestamp == null ? '' : '?at=${timestamp.millisecondsSinceEpoch}';
    final response = await WebUtil.get(_mojangApi, 'users/profiles/minecraft/$username$time');
    final map =  await WebUtil.getJsonFromResponse(response);
    if (!(map is Map)) throw Exception('Content returned from the server is in an unexpected format.');
    if (map['error'] != null) throw Exception(map['errorMessage']);
    return Pair<String, String>(username, map['id']);
  }

  /// Gets a List of player UUIDs by a List of player names.
  /// 
  /// - usernames are case corrected.
  /// - invalid usernames are not returned.
  static Future<List<Pair<String, String>>> getUuids(List<String> usernames) async {
    final response = await WebUtil.post(_mojangApi, 'profiles/minecraft', usernames, {'Content-Type': 'application/json'});
    final list = await WebUtil.getJsonFromResponse(response);
    if (!(list is List<Map>)) {
      throw Exception('Content returned from the server is in an unexpected format.');
    } else {
      return list.map<Pair<String, String>>((Map v) => Pair<String, String>(v['name'], v['id'])).toList();
    }
  }

  /// Gets the name history for a `uuid`.
  static Future<List<Name>> getNameHistory(String uuid) async {
    final response = await WebUtil.get(_mojangApi, 'user/profiles/$uuid/names');
    final list = await WebUtil.getJsonFromResponse(response);
    final ret = <Name>[];
    list.forEach((dynamic v) => ret.add(Name.fromJson(v)));
    return ret;
  }

  /// Get's the user profile including skin/cape.
  static Future<Profile> getProfile(String uuid) async {
    final response = await WebUtil.get(_sessionApi, 'session/minecraft/profile/$uuid');
    final map = await WebUtil.getJsonFromResponse(response);
    final profile = Profile.fromJson(map);
    return profile;
  }

  /// Changes the Mojang acccount name to `newName`.
  // TODO: Improved return type including error message. Or just throw an error?
  static Future<bool> changeName(String uuid, String newName, String accessToken, String password) async {
    final body = <String, String>{
      'name': newName, 
      'password': password
    };
    final headers = <String, String>{
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    };
    final response = await WebUtil.post(_mojangApi, 'user/profile/$uuid/name', body, headers);
    if (response.statusCode != 204) {
      return false;
      /* switch (response.statusCode) {
        case 400: throw Exception('Name is unavailable.');
        case 401: throw Exception('Unauthorized.');
        case 403: throw Exception('Forbidden.');
        case 504: throw Exception('Timed out.');
        default: throw Exception('Unexpected error occured.');
      } */
    } else {
      return true;
    }
  }

  /// Reserves the `newName` for your Mojang Account.
  // TODO: Improved return type including error message. Or just throw an error?
  static Future<bool> reserveName(String newName, String accessToken) async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Origin': 'https://checkout.minecraft.net',
    };
    final response = await WebUtil.put(_mojangApi, 'user/profile/agent/minecraft/name/$newName', {}, headers);
    if (response.statusCode != 204) {
      return false;
      /* switch (response.statusCode) {
        case 400: throw Exception('Name is unavailable.');
        case 401: throw Exception('Unauthorized.');
        case 403: throw Exception('Forbidden.');
        case 504: throw Exception('Timed out.');
        default: throw Exception('Unexpected error occured.');
      } */
    } else {
      return true;
    }
  }

  /// Reset's the skin.
  static Future<void> resetSkin(String uuid, String accessToken) async {
    final headers = {
      'Authorization': 'Bearer $accessToken',
    };
    final _ = await WebUtil.delete(_mojangApi, 'user/profile/$uuid/skin', headers);
  }

  /// Get's Minecraft: Java Edition, Minecraft Dungeons, Cobalt and Scrolls purchase statistics.
  ///
  /// Returns total statistics for ALL games included. To get individual statistics, call this
  /// function for each MinecraftStatisticsItem or each game.
  static Future<MinecraftStatistics> getStatistics(List<MinecraftStatisticsItem> items) async {
    final payload = {
      'metricKeys': [
        for (MinecraftStatisticsItem item in items) item.name,
      ]
    };
    final headers = <String, String>{'Content-Type': 'application/json'};
    final response = await WebUtil.post(_mojangApi, 'orders/statistics', payload, headers);
    final data = await WebUtil.getJsonFromResponse(response);
    print(data);
    return MinecraftStatistics.fromJson(data);
  }
}
