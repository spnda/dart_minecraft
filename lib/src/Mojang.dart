import 'dart:async';

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
}
