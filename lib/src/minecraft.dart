import 'package:dart_minecraft/src/minecraft/minecraft_news.dart';
import 'package:dart_minecraft/src/minecraft/minecraft_patch.dart';
import 'package:dart_minecraft/src/minecraft/version_manifest.dart';
import 'package:dart_minecraft/src/utilities/web_util.dart';

/// Includes all Minecraft and Minecraft Launcher specific functionality.
class Minecraft {
  static const String _launcherContent = 'https://launchercontent.mojang.com';
  static const String _launcherMeta = 'https://launchermeta.mojang.com/';

  /// Returns a List of the most recent news for Minecraft.
  ///
  /// This data can be found on the "News" page in the official
  /// Minecraft Launcher.
  static Future<List<MinecraftNews>> getNews() async {
    final response = (await WebUtil.get(_launcherContent, 'javaNews.json'));
    final data = await WebUtil.getJsonFromResponse(response);
    final news = <MinecraftNews>[];
    for (Map<String, dynamic> e in data['entries']) {
      news.add(MinecraftNews.fromJson(e));
    }
    return news;
  }

  /// Returns a List of the most recent patch notes for Minecraft: Java Edition.
  ///
  /// These can also be found in the official Minecraft Launcher under
  /// the "patch notes" page.
  static Future<List<MinecraftPatch>> getPatchNotes() async {
    final response =
        (await WebUtil.get(_launcherContent, 'javaPatchNotes.json'));
    final data = await WebUtil.getJsonFromResponse(response);
    final patches = <MinecraftPatch>[];
    for (Map<String, dynamic> e in data['entries']) {
      patches.add(MinecraftPatch.fromJson(e));
    }
    return patches;
  }

  /// Returns a Manifest with all Minecraft: Java Edition Versions,
  /// including alpha/beta and snapshot versions.
  static Future<VersionManifest> getVersions() async {
    final response =
        (await WebUtil.get(_launcherMeta, 'mc/game/version_manifest.json'));
    final data = await WebUtil.getJsonFromResponse(response);
    return VersionManifest.fromJson(data);
  }
}
