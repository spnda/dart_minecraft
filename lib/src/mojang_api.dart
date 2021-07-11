import 'dart:async';

import 'package:http/http.dart' as http;

import 'exceptions/auth_exception.dart';
import 'exceptions/too_many_requests_exception.dart';
import 'minecraft/blocked_server.dart';
import 'minecraft/minecraft_statistics.dart';
import 'mojang/mojang_status.dart';
import 'mojang/name.dart';
import 'mojang/profile.dart';
import 'mojang/security_challenges.dart';
import 'utilities/pair.dart';
import 'utilities/web_util.dart';

typedef PlayerUuid = Pair<String, String>;

const String _statusApi = 'status.mojang.com';
const String _mojangApi = 'api.mojang.com';
const String _mojangAccountApi = 'account.mojang.com';
const String _sessionApi = 'sessionserver.mojang.com';
const String _minecraftServicesApi = 'api.minecraftservices.com';

/// Returns the Mojang and Minecraft API and website status
///
/// Might throw a [Exception] if no data or invalid data was
/// returned.
Future<MojangStatus> getStatus() async {
  final response = await request(http.get, _statusApi, 'check');
  if (response.statusCode != 200) {
    throw Exception('Failed to get Mojang API status.');
  }
  try {
    final list = parseResponseList(response);
    return MojangStatus.fromJson(list);
  } on FormatException catch (_) {
    return MojangStatus.empty();
  }
}

/// Returns the UUID for player [username].
///
/// A [timestamp] can be passed to retrieve the UUID for the player with [username]
/// at that point in time. **Warning**: Since November 2020, the [timestamp] is
/// ignored, see [WEB-3367](https://bugs.mojang.com/browse/WEB-3367).
Future<PlayerUuid> getUuid(String username, {DateTime? timestamp}) async {
  final time =
      timestamp == null ? '' : '?at=${timestamp.millisecondsSinceEpoch}';

  final response = await request(
      http.get, _mojangApi, 'users/profiles/minecraft/$username$time');
  final map = parseResponseMap(response);
  if (map['error'] != null) {
    if (response.statusCode == 404) {
      throw ArgumentError.value(
          username, 'username', 'No user was found for given username');
    } else if (response.statusCode == 400) {
      throw ArgumentError.value(
          timestamp, 'timestamp', 'The timestamp is invalid.');
    }
    throw Exception(map['errorMessage']);
  }

  return PlayerUuid(username, map['id']);
}

/// Returns a List of player UUIDs by a List of player names.
///
/// Usernames are not case sensitive and ones which are invalid or not found are omitted.
Future<List<PlayerUuid>> getUuids(List<String> usernames) async {
  final response = await requestBody(
      http.post, _mojangApi, 'profiles/minecraft', usernames,
      headers: {'content-type': 'application/json'});
  final list = parseResponseList(response);
  return list.map<PlayerUuid>((v) => PlayerUuid(v['name'], v['id'])).toList();
}

/// Get the name and UUID by a player's UUID.
///
/// If you exceed the rate limit, you will have to wait atleast 30 seconds
/// before requesting again.
Future<PlayerUuid> getName(String uuid) async {
  final response = await request(http.get, _mojangApi, 'user/profile/$uuid');
  switch (response.statusCode) {
    case 204:
      throw ArgumentError.value(uuid, 'uuid');
    case 400:
      throw ArgumentError.value(
          uuid, 'uuid', parseResponseMap(response)['errorMessage']);
    case 429:
      throw TooManyRequestsException(
          parseResponseMap(response)['errorMessage']);
  }
  final map = parseResponseMap(response);
  return PlayerUuid(map['name'], map['id']);
}

/// Returns the name history for the account with [uuid].
Future<List<Name>> getNameHistory(String uuid) async {
  final response =
      await request(http.get, _mojangApi, 'user/profiles/$uuid/names');
  if (response.statusCode == 204 ||
      response.statusCode == 400 ||
      response.statusCode == 404) {
    throw ArgumentError.value(
        uuid, 'uuid', 'User for given UUID could not be found or is invalid.');
  }
  final list = parseResponseList(response);
  return Future.value(list.map((dynamic v) => Name.fromJson(v)).toList());
}

/// Returns the user profile including skin/cape information.
///
/// Using [getProfile(uuid).getTextures] both skin and cape textures can be obtained.
Future<Profile> getProfile(String uuid) async {
  final response =
      await request(http.get, _sessionApi, 'session/minecraft/profile/$uuid');
  final map = parseResponseMap(response);
  if (response.statusCode == 400 || response.statusCode == 404) {
    throw ArgumentError.value(
        uuid, 'uuid', 'User for given UUID could not be found or is invalid.');
  } else if (response.statusCode == 429 && map['error'] != null) {
    throw TooManyRequestsException(map['errorMessage']);
  }
  return Profile.fromJson(map);
}

/// Changes the Mojang account name to [newName].
Future<bool> changeName(
    String uuid, String newName, String accessToken, String password) async {
  final body = <String, String>{'name': newName, 'password': password};
  final headers = <String, String>{
    'authorization': 'Bearer $accessToken',
    'content-type': 'application/json'
  };
  final response = await requestBody(
      http.post, _minecraftServicesApi, 'user/profile/$uuid/name', body,
      headers: headers);

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
Future<bool> reserveName(String newName, String accessToken) async {
  final headers = {
    'authorization': 'Bearer $accessToken',
    'Origin': 'https://checkout.minecraft.net',
  };
  final response = await requestBody(
      http.put, _mojangApi, 'user/profile/agent/minecraft/name/$newName', {},
      headers: headers);
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

/// Essentially the same as [isNameAvailable], however
/// this function does not require any authentication.
/// It is not exactly accurate, however can be used to determine
/// if a name was blocked by Mojang's name filter and/or the name
/// is used on a empty Mojang account.
///
/// If a name is not valid, this will be false. This includes names
/// shorter than 2 characters or longer than 16 characters or names
/// that use invalid characters.
Future<bool> isNameAvailableNoAuth(String name) async {
  final response =
      await request(http.get, _mojangAccountApi, 'available/minecraft/$name');
  if (response.statusCode != 200) return false;
  return response.body.trim() == 'AVAILABLE';
}

/// Checks whether or not given [name] is available or not.
/// A name must be at least 3 characters and at most 16 characters
/// long and not include any invalid characters to be valid.
/// If your access token is invalid, this will silently fail
/// and return false.
Future<bool> isNameAvailable(String name, String accessToken) async {
  final response = await request(
      http.get, _minecraftServicesApi, 'minecraft/profile/name/$name/available',
      headers: {'authorization': 'Bearer $accessToken'});
  if (response.statusCode == 401) return false;
  final body = parseResponseMap(response);
  if (response.statusCode == 429) {
    throw TooManyRequestsException(body['errorMessage']);
  }
  // Can also be 'DUPLICATE' (already taken) or
  // 'NOT_ALLOWED' (blocked by name filter).
  return body['status'] == 'AVAILABLE';
}

/// Reset's the player's skin.
Future<void> resetSkin(String uuid, String accessToken) async {
  final headers = {
    'authorization': 'Bearer $accessToken',
  };
  final response = await request(
      http.delete, _mojangApi, 'user/profile/$uuid/skin',
      headers: headers);
  if (response.statusCode == 401) {
    final data = parseResponseMap(response);
    throw AuthException(data['errorMessage']);
  }
}

/// Change the skin with the texture of the skin at [skinUrl].
Future<bool> changeSkin(Uri skinUrl, String accessToken,
    [SkinModel skinModel = SkinModel.classic]) async {
  final headers = {
    'authorization': 'Bearer $accessToken',
  };
  final data = {
    'variant': skinModel.toString().replaceFirst('SkinModel', ''),
    'url': skinUrl,
  };
  final response = await requestBody(
      http.post, _minecraftServicesApi, 'minecraft/profile/skins', data,
      headers: headers);
  switch (response.statusCode) {
    case 401:
      throw AuthException(AuthException.invalidCredentialsMessage);
  }
  return true;
}

/// Get's Minecraft: Java Edition, Minecraft Dungeons, Cobalt and Scrolls purchase statistics.
///
/// Returns total statistics for ALL games included. To get individual statistics, call this
/// function for each MinecraftStatisticsItem or each game.
Future<MinecraftStatistics> getStatistics(
    List<MinecraftStatisticsItem> items) async {
  if (items.isEmpty) {
    throw ArgumentError.value(
        items, 'items', 'The list of MinecraftStatisticItems cannot be empty.');
  }
  final payload = {
    'metricKeys': [
      for (MinecraftStatisticsItem item in items) item.name,
    ]
  };
  final headers = <String, String>{'content-type': 'application/json'};
  final response = await requestBody(
      http.post, _mojangApi, 'orders/statistics', payload,
      headers: headers);
  final data = parseResponseMap(response);
  return MinecraftStatistics.fromJson(data);
}

/// Returns a list of blocked servers.
Future<List<BlockedServer>> getBlockedServers() async {
  final response = await request(http.get, _sessionApi, 'blockedservers');
  final data = response.body.split('\n');
  final ret = <BlockedServer>[];
  for (final server in data) {
    ret.add(BlockedServer.parse(server));
  }
  return ret;
}

/// Checks whether or not the user has to answer the security challenges.
/// This will return true if the current location is not verified and needs
/// to be verified using [getSecurityChallenges] and [answerSecurityChallenges].
Future<bool> areSecurityChallengesNeeded(String accessToken) async {
  final headers = {
    'authorization': 'Bearer $accessToken',
  };
  final response = await request(http.get, _mojangApi, 'user/security/location',
      headers: headers);
  return response.statusCode == 403;
}

/// Fetches the list of security challenges one must answer
/// to access the account.
/// Check if this is needed using [areSecurityChallengesNeeded].
Future<List<SecurityChallenge>> getSecurityChallenges(
    String accessToken) async {
  final headers = {
    'authorization': 'Bearer $accessToken',
  };
  final response = await request(
      http.get, _mojangApi, 'user/security/challenges',
      headers: headers);
  if (response.statusCode == 401) {
    throw AuthException(AuthException.invalidCredentialsMessage);
  }
  final list = parseResponseList(response);
  return list.map((f) => SecurityChallenge.fromJson(f)).toList();
}

/// Allows an authenticated user to verify their location by
/// answering their security questions.
/// You can get the security challenges through [getSecurityChallenges].
/// Also check if this is needed using [areSecurityChallengesNeeded].
Future<bool> answerSecurityChallenges(
    String accessToken, List<SecurityChallenge> answers) async {
  /// Verify we have enough answers passed.
  if (answers.length != 3) {
    throw ArgumentError.value(
        answers, 'answers', 'We require at least 3 answers.');
  }

  final headers = {
    'authorization': 'Bearer $accessToken',
    'content-type': 'application/json',
  };
  final body = [for (final answer in answers) answer.asAnswerJson];
  final response = await requestBody(
      http.post, _mojangApi, 'user/security/location', body,
      headers: headers);
  if (response.statusCode == 403) {
    throw ArgumentError.value(
        answers, 'answers', 'At least one answer was incorrect.');
  }
  return response.statusCode == 204;
}
