import 'dart:async';
import 'dart:io';

import 'package:uuid/uuid.dart';

import 'exceptions/auth_exception.dart';
import 'minecraft/minecraft_statistics.dart';
import 'mojang/mojang_account.dart';
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
  static const String _authserver = 'https://authserver.mojang.com/';
  static const String _minecraftServices = 'https://api.minecraftservices.com/';

  /// Returns the Mojang and Minecraft API and website status
  static Future<MojangStatus> checkStatus() async {
    final response = await WebUtil.get(_statusApi, 'check');
    final list = await WebUtil.getJsonFromResponse(response);
    if (!(list is List)) {
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
  static Future<Pair<String, String>> getUuid(String username, {DateTime timestamp}) async {
    final time =
        timestamp == null ? '' : '?at=${timestamp.millisecondsSinceEpoch}';
    final response = await WebUtil.get(
        _mojangApi, 'users/profiles/minecraft/$username$time');
    final map = await WebUtil.getJsonFromResponse(response);
    if (map == null) {
      throw ArgumentError.value(username, 'username', 'No user was found for given username');
    }
    if (!(map is Map)) {
      throw Exception(
          'Content returned from the server is in an unexpected format.');
    }
    if (map['error'] != null) throw Exception(map['errorMessage']);
    return Pair<String, String>(username, map['id']);
  }

  /// Returns a List of player UUIDs by a List of player names.
  ///
  /// Usernames are not case sensitive and ones which are invalid or not found are ommitted.
  static Future<List<Pair<String, String>>> getUuids(List<String> usernames) async {
    final response = await WebUtil.post(_mojangApi, 'profiles/minecraft',
        usernames, {HttpHeaders.contentTypeHeader: 'application/json'});
    final list = await WebUtil.getJsonFromResponse(response);
    if (!(list is List<Map>)) {
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
    final ret = <Name>[];
    list.forEach((dynamic v) => ret.add(Name.fromJson(v)));
    return ret;
  }

  /// Returns the user profile including skin/cape information.
  ///
  /// Using [getProfile(uuid).getTextures] both skin and cape textures can be obtained.
  static Future<Profile> getProfile(String uuid) async {
    final response =
        await WebUtil.get(_sessionApi, 'session/minecraft/profile/$uuid');
    final map = await WebUtil.getJsonFromResponse(response);
    final profile = Profile.fromJson(map);
    return profile;
  }

  /// Changes the Mojang acccount name to [newName].
  static Future<bool> changeName(String uuid, String newName, String accessToken, String password) async {
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
        case 400: throw ArgumentError('Name is invalid, longer than 16 characters or contains characters other than (a-zA-Z0-9_)');
        case 401: throw AuthException(AuthException.invalidCredentialsMessage);
        case 403: throw Exception('Name is unavailable (Either taken or has not become available).');
        case 500: throw Exception('Timed out.');
        default: throw Exception('Unexpected error occured.');
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
        default: throw Exception('Unexpected error occured.');
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
  static Future<bool> changeSkin(Uri skinUrl, String accessToken, [SkinModel skinModel = SkinModel.classic]) async {
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $accessToken',
    };
    final data = {
      'variant': skinModel.toString().replaceFirst("SkinModel", ""),
      'url': skinUrl,
    };
    final response = await WebUtil.post(_minecraftServices, 'minecraft/profile/skins', data, headers);
    switch (response.statusCode) {
      case 401: throw AuthException(AuthException.invalidCredentialsMessage);
      default: {
        print(response);
        return true;
      }
    }
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
    final headers = <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json'
    };
    final response =
        await WebUtil.post(_mojangApi, 'orders/statistics', payload, headers);
    final data = await WebUtil.getJsonFromResponse(response);
    return MinecraftStatistics.fromJson(data);
  }

  /// Authenticates a user with given credentials [username] and [password].
  static Future<MojangAccount> authenticate(String username, String password) async {
    final payload = {
      'agent': {'name': 'Minecraft', 'version ': 1},
      'username': username,
      'password': password,
      'clientToken': Uuid().v4(),
      'requestUser': true
    };
    final response =
        await WebUtil.post(_authserver, 'authenticate', payload, {});
    final data = await WebUtil.getJsonFromResponse(response);
    if (data['error'] != null) throw AuthException(data['errorMessage']);
    return MojangAccount.fromJson(data);
  }

  /// Refreshes the [account]. The [account] data will be overriden with the new 
  /// refreshed data. The return value is also the same [account] object.
  static Future<MojangAccount> refresh(MojangAccount account) async {
    final payload = {
      'accessToken': account.accessToken,
      'clientToken': account.clientToken,
      'selectedProfile': {
        'id': account.selectedProfile.id,
        'name': account.selectedProfile.name,
      },
      'requestUser': true,
    };
    final response = await WebUtil.post(_authserver, 'refresh', payload, {});
    final data = await WebUtil.getJsonFromResponse(response);
    if (data['error'] != null) {
      switch (data['error']) {
        case 'ForbiddenOperationException':
          throw AuthException(AuthException.invalidCredentialsMessage);
        default:
          throw Exception(data['errorMessage']);
      }
    }

    // Insert the data into our old account object.
    account
      ..accessToken = data['accessToken']
      ..clientToken = data['clientToken'];
    if (data['selectedProfile'] != null) {
      account.selectedProfile
        ..id = data['selectedProfile']['id']
        ..name = data['selectedProfile']['name'];
    }
    if (data['user'] != null) {
      account.user
        ..id = data['user']['id']
        ..preferredLanguage = (data['user']['properties'] as List)
            ?.where((f) => (f as Map)['name'] == 'preferredLanguage')
            ?.first
        ..twitchOAuthToken = (data['user']['properties'] as List)
            ?.where((f) => (f as Map)['name'] == 'twitch_access_token')
            ?.first;
    }

    return account;
  }

  /// Checks if given [accessToken] and [clientToken] are still valid.
  ///
  /// [clientToken] is optional, though if provided should match the client token
  /// that was used to obtained given [accessToken].
  static Future<bool> validate(String accessToken, {String clientToken}) async {
    final payload = {
      'accessToken': accessToken,
    };
    if (clientToken != null) {
      payload.putIfAbsent('clientToken', () => clientToken);
    }
    final response = await WebUtil.post(_authserver, 'validate', payload, {});
    return response?.statusCode == 204;
  }

  /// Signs the user out and invalidates the accessToken.
  static Future<bool> signout(String username, String password) async {
    final payload = {
      'username': username,
      'password': password,
    };
    final response = await WebUtil.post(_authserver, 'signout', payload, {});
    final data = await WebUtil.getResponseBody(response);
    return data?.isEmpty;
  }

  /// Invalidates the accessToken of given [mojangAccount].
  static Future<bool> invalidate(MojangAccount mojangAccount) async {
    final payload = {
      'accessToken': mojangAccount.accessToken,
      'clientToken': mojangAccount.clientToken,
    };
    final response = await WebUtil.post(_authserver, 'invalidate', payload, {});
    final data = await WebUtil.getResponseBody(response);
    return data?.isEmpty;
  }
}
