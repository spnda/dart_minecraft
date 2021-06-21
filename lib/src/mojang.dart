import 'dart:async';

import 'minecraft/blocked_server.dart';
import 'minecraft/minecraft_statistics.dart';
import 'mojang/mojang_status.dart';
import 'mojang/name.dart';
import 'mojang/profile.dart';
import 'mojang_api.dart' as api;

/// Mojang API specific functionality.
///
/// Mojang account, authentication and status APIs.
@deprecated
class Mojang {
  /// Returns the Mojang and Minecraft API and website status
  @deprecated
  static Future<MojangStatus> checkStatus() async {
    return api.getStatus();
  }

  /// Returns the UUID for player [username].
  ///
  /// A [timestamp] can be passed to retrieve the UUID for the player with [username]
  /// at that point in time.
  @deprecated
  static Future<api.PlayerUuid> getUuid(String username,
      {DateTime? timestamp}) async {
    return api.getUuid(username, timestamp: timestamp);
  }

  /// Returns a List of player UUIDs by a List of player names.
  ///
  /// Usernames are not case sensitive and ones which are invalid or not found are omitted.
  @deprecated
  static Future<List<api.PlayerUuid>> getUuids(List<String> usernames) async {
    return api.getUuids(usernames);
  }

  /// Returns the name history for the account with [uuid].
  @deprecated
  static Future<List<Name>> getNameHistory(String uuid) async {
    return api.getNameHistory(uuid);
  }

  /// Returns the user profile including skin/cape information.
  ///
  /// Using [getProfile(uuid).getTextures] both skin and cape textures can be obtained.
  @deprecated
  static Future<Profile> getProfile(String uuid) async {
    return api.getProfile(uuid);
  }

  /// Changes the Mojang account name to [newName].
  @deprecated
  static Future<bool> changeName(
      String uuid, String newName, String accessToken, String password) async {
    return api.changeName(uuid, newName, accessToken, password);
  }

  /// Reserves the [newName] for this Mojang Account.
  @deprecated
  static Future<bool> reserveName(String newName, String accessToken) async {
    return api.reserveName(newName, accessToken);
  }

  /// Reset's the player's skin.
  @deprecated
  static Future<void> resetSkin(String uuid, String accessToken) async {
    return api.resetSkin(uuid, accessToken);
  }

  /// Change the skin with the texture of the skin at [skinUrl].
  @deprecated
  static Future<bool> changeSkin(Uri skinUrl, String accessToken,
      [SkinModel skinModel = SkinModel.classic]) async {
    return api.changeSkin(skinUrl, accessToken, skinModel);
  }

  /// Get's Minecraft: Java Edition, Minecraft Dungeons, Cobalt and Scrolls purchase statistics.
  ///
  /// Returns total statistics for ALL games included. To get individual statistics, call this
  /// function for each MinecraftStatisticsItem or each game.
  @deprecated
  static Future<MinecraftStatistics> getStatistics(
      List<MinecraftStatisticsItem> items) async {
    return api.getStatistics(items);
  }

  /// Returns a list of blocked servers.
  @deprecated
  static Future<List<BlockedServer>> getBlockedServers() async {
    return api.getBlockedServers();
  }
}
