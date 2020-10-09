import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:dart_minecraft/src/Mojang/Name.dart';
import 'package:dart_minecraft/src/Mojang/Profile.dart';
import 'package:dart_minecraft/src/Mojang/Status/MojangStatus.dart';
import 'package:dart_minecraft/src/utilities/Pair.dart';

/// Includes all Mojang specific functionality.
/// 
/// This includes account managing and status information.
class Mojang {
  static const String _statusApi  = 'https://status.mojang.com/';
  static const String _mojangApi  = 'https://api.mojang.com/';
  static const String _sessionApi = 'https://sessionserver.mojang.com/';

  static final HttpClient _client = HttpClient();

  /// Gets the API Status
  static Future<MojangStatus> checkStatus() async {
    final response = await _get(_statusApi, 'check');
    final list = await _getJsonFromResponse(response);
    if (!(list is List)) {
      throw Exception('Content returned from the server is in an unexpected format.');
    } else {
      return MojangStatus.fromJson(list);
    }
  }

  /// Returns the UUID for player [username].
  /// 
  /// A [timestamp] can be passed to retrieve the UUID for the player with [username]
  /// at [timestamp].
  static Future<Pair<String, String>> getUuid(String username, {DateTime timestamp}) async {
    final time = timestamp == null ? '' : '?at=${timestamp.millisecondsSinceEpoch}';
    final response = await _get(_mojangApi, 'users/profiles/minecraft/$username$time');
    final map =  await _getJsonFromResponse(response);
    if (!(map is Map)) throw Exception('Content returned from the server is in an unexpected format.');
    if (map['error'] != null) throw Exception(map['errorMessage']);
    return Pair<String, String>(username, map['id']);
  }

  /// Gets a List of player UUIDs by a List of player names.
  /// 
  /// - usernames are case corrected.
  /// - invalid usernames are not returned.
  static Future<List<Pair<String, String>>> getUuids(List<String> usernames) async {
    final response = await _post(_mojangApi, 'profiles/minecraft', usernames, {'Content-Type': 'application/json'});
    final list = await _getJsonFromResponse(response);
    if (!(list is List<Map>)) {
      throw Exception('Content returned from the server is in an unexpected format.');
    } else {
      return list.map<Pair<String, String>>((Map v) => Pair<String, String>(v['name'], v['id'])).toList();
    }
  }

  /// Gets the name history for a [uuid].
  static Future<List<Name>> getNameHistory(String uuid) async {
    final response = await _get(_mojangApi, 'user/profiles/$uuid/names');
    final list = await _getJsonFromResponse(response);
    final ret = <Name>[];
    list.forEach((dynamic v) => ret.add(Name.fromJson(v)));
    return ret;
  }

  /// Get's the user profile including skin/cape.
  static Future<Profile> getProfile(String uuid) async {
    final response = await _get(_sessionApi, 'session/minecraft/profile/$uuid');
    final map = await _getJsonFromResponse(response);
    final profile = Profile.fromJson(map);
    return profile;
  }

  /// Parses the [response]'s body into a Map<String, dynamic> or List<dynamic>.
  static Future<dynamic> _getJsonFromResponse(HttpClientResponse response) {
    final contents = StringBuffer();
    final completer = Completer<dynamic>();
    response.transform(utf8.decoder).listen(
      (data) => contents.write(data), 
      onDone: () => completer.complete(json.decode(contents.toString()))
    );
    return completer.future;
  }

  static Future<HttpClientResponse> _get(String base, String api) async {
    if (!base.endsWith('/')) base += '/';
    final request = await _client.getUrl(Uri.parse('$base$api'));
    return request.close();
  }

  static Future<HttpClientResponse> _post(String base, String api, dynamic body, Map<String, dynamic> headers) async {
    if (!base.endsWith('/')) base += '/';
    if (!(body is List) && !(body is Map)) throw Exception('body must be a List or Map');
    final request = await _client.postUrl(Uri.parse('$base$api'));
    for (MapEntry e in headers.entries) {
      request.headers.add(e.key, e.value);
    }
    return request.close();
  }
}
